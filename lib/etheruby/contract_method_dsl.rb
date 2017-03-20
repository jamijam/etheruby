require 'sha3'

module Etheruby

  class ContractMethodDSL

    attr_reader :data

    def initialize(name)
      @data = { name: name }
    end

    def parameters(*args)
      data[:params] = args
    end

    def array(type, size=nil)
      if size
        "#{type}[#{size}]"
      else
        "#{type}[]"
      end
    end

    def returns(args)
      data[:returns] = args
    end

    def from(_address)
      data[:from] = "0x#{_address.to_s(16)}"
    end

    def gas(_gas)
      data[:gas] = "0x#{_gas.to_s(16)}"
    end

    def gasPrice(_gp)
      data[:gasPrice] = "0x#{_gas.to_s(16)}"
    end

    def value(_v)
      data[:value] = "0x#{_gas.to_s(16)}"
    end

    def force_transaction!
      data[:force_transac] = true
    end

    def validate!
      data[:params] = [] unless data.has_key? :params
      signature = "#{@data[:name]}(#{data[:params].join(',')})"
      hashed_signature = ::SHA3::Digest.new(:sha256).hexdigest(signature)
      data[:signature] = "0x#{hashed_signature[0..7]}"
      data
    end

  end

end
