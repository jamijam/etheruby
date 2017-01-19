require_relative 'base'
require_relative 'address'

module Etheruby::Encoders

  class Function < Base

    def encode
      (data[:address].to_s(16) + data[:selector].to_s(16)).ljust(64, '0')
    end

    def decode
      address, selector = data[0..39], data[40..47]
      return {
        address: Address.new(address).decode[0],
        selector: "0x#{selector}"
      }, 32
    end

    def to_s
      encode
    end

  end

end
