require_relative 'base'
require_relative 'bytes'

module Etheruby::Encoders

  class String < Base
    def encode
      Bytes.new(data.codepoints).encode
    end

    def decode
      Bytes.new(data).decode.pack('U*')
    end
  end

end
