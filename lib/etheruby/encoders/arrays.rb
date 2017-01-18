require_relative 'base'
require_relative 'int'
require_relative '../treat_variable'

module Etheruby::Encoders

  class StaticArray < Base

    attr_reader :type, :size

    def initialize(_type, _size, _data)
      super(_data)
      @type = _type
      @size = _size
    end

    def to_s
      encode
    end

    def encode
      if Etheruby::is_static_type? type
        data.map{ |d| Etheruby::treat_variable(type, d, :encode) }.join
      else
        head_x = ''
        enc_x = ''
        c_pos = size * 32
        data.map { |d|
          treated = Etheruby::treat_variable(type, d, :encode)
          {size: treated.length/2, value: treated}
        }.each { |item|
          head_x += Uint.new(c_pos).encode
          c_pos += item[:size]
          enc_x += item[:value]
        }
        head_x + enc_x
      end
    end

    def decode
      if Etheruby::is_static_type?(type)
        sub_decode(0, data)
      else
        sub_decode(size*32, data[size*2*32..data.length])
      end
    end

    private

      def sub_decode(total_taken, real_data)
        values = []
        loop do
          v, s = Etheruby::treat_variable(type, real_data, :decode)
          v, s = v.decode if v.is_a? StaticArray or v.is_a? DynamicArray
          values << v
          total_taken += s
          break if values.count == size
          real_data = real_data[s*2..real_data.length]
        end
        return values, total_taken
      end

  end

  class DynamicArray < Base

    attr_reader :type

    def initialize(_type, _data)
      super(_data)
      @type = _type
    end

    def to_s
      encode
    end

    def encode
      Uint.new(data.count).encode + \
        StaticArray.new(type, data.count, data).encode
    end

    def decode
      size, taken = Uint.new(data[0..63]).decode
      v, s = StaticArray.new(type, size, data[64..data.length]).decode
      return v, s+taken
    end

  end

end
