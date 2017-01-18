require_relative 'base'
require_relative 'int'

module Etheruby::Encoders

  class Address < Base
    def encode
      Uint.new(data).encode
    end

    def decode
      "0x#{Uint.new(data).decode.to_s(16)}"
    end
  end

end
