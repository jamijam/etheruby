require_relative 'base'

module Etheruby::Encoders

  class Int < Base

    def encode(pad_to=64)
      if data >= 0
        data.to_s(16).rjust(pad_to, '0')
      else
        mask = (1 << pad_to*4) - 1
        (data & mask).to_s(16).rjust(pad_to, 'f')
      end
    end

    def decode
      in_int = data.to_i(16)
      in_bin = in_int.to_s(2).rjust(64, '0')
      if in_bin[0] == '1'
        -(in_bin.split("").map{ |i| i == '1' ? '0' : '1' }.join.to_i(2) + 1)
      else
        in_int
      end
    end

  end

  class Uint < Base

    def encode(pad_to=64)
      raise InvalidFormatForDataError.new("Unsigned integer #{data} < 0") if data < 0
      Int.new(data).encode(pad_to)
    end

    def decode
      data.to_i(16)
    end

  end

end
