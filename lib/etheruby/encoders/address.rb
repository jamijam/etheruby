require_relative 'base'
require_relative 'int'

module Etheruby::Encoders

  class Address < Base
    def encode
      Uint.new(data).encode
    end

    def decode
      v, s = Uint.new(data).decode
      return "0x#{v.to_s(16)}", s
    end
  end

end
