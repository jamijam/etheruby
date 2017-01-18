require_relative 'base'
require_relative 'int'

module Etheruby::Encoders

  class Byte < Base

    attr_reader :size

    def initialize(_size,_data)
      super(_data)
      @size = _size
    end

    def encode
      data.map{ |b|
        b.to_s(16).rjust(2,'0')
      }.join.ljust(determinate_closest_padding(size)*2, '0')
    end

    def decode
      return data[0..(size*2)-1].split('').each_slice(2).map{ |b| b.join.to_i(16) },
             determinate_closest_padding(size)
    end

  end

  class Bytes < Base

    def encode
      Uint.new(data.length).encode + Byte.new(data.length, data).encode
    end

    def decode
      size = Uint.new(data[0..63]).decode[0]
      return Byte.new(size,data[64..data.length]).decode[0], determinate_closest_padding(size+32)
    end

  end

end
