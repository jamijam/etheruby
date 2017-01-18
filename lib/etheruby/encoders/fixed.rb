require_relative 'base'
require_relative 'int'

module Etheruby::Encoders

  class FixedBase < Base
    attr_reader :size_i, :size_d

    def initialize(_size_i, _size_d, _data)
      super(_data)
      @size_i = _size_i
      @size_d = _size_d
    end

    protected

      def encode_decimal_representation(value)
        (0..@size_d-1).map {
          int_part, value = (value*2).to_i, (value*2) - (value*2).to_i
          int_part
        }.each_slice(8).map { |slice|
          slice.join.to_i(2).to_s(16).rjust(2,'0')
        }.join
      end

      def decode_decimal_representation(part)
        value = 0.0
        exp = -1
        bin_rpr = part.to_i(16).to_s(2).rjust(@size_d,'0')
        bin_rpr.split("").each do |bit|
          value += 2**exp if bit == '1'
          exp -= 1
        end
        value
      end
  end

  class Fixed < FixedBase

    def encode
      if data >= 0
        int_part, dec_part = data.to_i, data - data.to_i
      else
        int_part, dec_part = data.to_i, (data + data.to_i.abs).abs
      end
      Int.new(int_part).encode(size_i/4) + \
        encode_decimal_representation(dec_part).ljust((256-size_i)/4,'0')
    end

    def decode
      int_part = Int.new(data[0..(size_i/4)-1]).decode
      dec_part = decode_decimal_representation(data[(size_i / 4)..data.length])
      if int_part >= 0
        dec_part + int_part
      else
        -(dec_part + int_part.abs)
      end
    end

  end

  class Ufixed < FixedBase

    def encode
      raise InvalidFormatForDataError.new("Unsigned fixed #{data} < 0") if data < 0
      Fixed.new(size_i, size_d, data).encode
    end

    def decode
      Uint.new(data[0..(size_i/4)-1]).decode +
        decode_decimal_representation(data[(size_i / 4)..data.length])
    end

  end

end
