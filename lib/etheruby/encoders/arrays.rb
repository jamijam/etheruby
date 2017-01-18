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

    def encode
      if Etheruby::is_static_type? type
        data.map { |d| Etheruby::treat_variable(type, d, :encode) }.join
      else

      end
    end

    def decode
      values = []
      if Etheruby::is_static_type? type
        (0..(64*size)-1).step(64).map { |d|
          Etheruby::treat_variable(type, data[d..d+63], :decode)
        }
      else

      end
    end

  end

  class DynamicArray < Base

    attr_reader :type

    def initialize(_type, _data)
      super(_data)
      @type = _type
    end

    def encode
      Uint.new(data.count).encode + \
        StaticArray.new(type, data.count, data).encode
    end

    def decode
      size = Uint.new(data[0..63]).decode
      StaticArray.new(type, size, data[64..data.length]).decode
    end

  end

end
