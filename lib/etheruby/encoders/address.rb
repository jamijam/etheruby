require_relative 'base'
require_relative 'int'

module Etheruby::Encoders

  class Address < Base
    def encode
      if data.is_a?(::String)
        Uint.new(data[2..64].to_i(16)).encode
      else
        Uint.new(data).encode
      end
    end

    def decode
      v, s = Uint.new(data).decode
      return "0x#{v.to_s(16)}", s
    end
  end

end
