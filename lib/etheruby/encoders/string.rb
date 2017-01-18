require_relative 'base'
require_relative 'bytes'

module Etheruby::Encoders

  class String < Base
    def encode
      Bytes.new(data.codepoints).encode
    end

    def decode
      v, s = Bytes.new(data).decode
      return v.pack('U*'), s
    end
  end

end
