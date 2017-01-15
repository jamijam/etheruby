require 'digest/sha3'

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

    def returns(*args)
      data[:returns] = args
    end

    def method_missing(sym, *args)
      data[sym] = args[0]
    end

    def validate!
      data[:params] = [] unless data.has_key? :params
      signature = "#{@data[:name]}(#{data[:params].join(',')})"
      # Generating the signature of this method
      data[:signature] = "0x#{Digest::SHA3.hexdigest(signature,256)[0..7]}"
      data
    end

  end

end
