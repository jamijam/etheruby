module Etheruby

  class IncorrectTypeError < StandardError; end
  class ArgumentsCountError < StandardError; end

  # https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
  class ArgumentsGenerator

    attr_reader :params, :args

    def initialize(params, args)
      @params = params
      @args = args
    end

    def is_sized_type(param)
      param.to_s.match /^([a-z]+)(\d+)$/
    end

    def is_static_array_type(param)
      param.to_s.match(/^([a-z]+)\[(\d+)\]$/)
    end

    def is_dynamic_array_type(param)
      param.to_s.match(/^([a-z]+)\[\]$/)
    end

    def to_s
      raise ArgumentsCountError.new unless params.count == args.count
      arguments = ""
      # For each parameter of the method called, we
      # match the corresponding type to encode and we send the
      # parameter given to this encoder
      (0..params.count-1).each do |i|
        param, arg = params[i], args[i]
        if match = is_sized_type(param)
          # Parameter is a sized type, e.g. uint256, byte32 ...
          method_name = "#{match[1]}_encode".to_sym
          if respond_to?(method_name)
            arguments += send(method_name, match[2].to_i, arg)
          else
            raise IncorrectTypeError.new("Type #{param} cannot be encoded")
          end
        elsif match = is_static_array_type(param)
          # Parameter is a staticly sized array type, e.g. uint256[24]
          arguments += static_array(match[1], match[2].to_i, arg)
        elsif match = is_dynamic_array_type(param)
          # Parameter is a dynamicaly sized array type, e.g. uint256[]
          arguments += dynamic_array(match[1], arg)
        else
          # Parameter is a single-word type : string, bytes, address etc...
          method_name = "#{param}_encode".to_sym
          if respond_to?(method_name)
            arguments += send(method_name, arg)
          else
            raise IncorrectTypeError.new("Type #{param} cannot be encoded")
          end
        end
      end
      arguments
    end

    ##
    # int<X> encoding
    def int_encode(size, arg)
      if arg >= 0
          arg.to_s(16).rjust(size / 4, '0')
      else
          mask = (1 << size) - 1
          (arg & mask).to_s(16)
      end
    end

    ##
    # uint<X> encoding
    def uint_encode(size, arg)
      arg.to_s(16).rjust(size / 4,'0')
    end

    def fixed_encode(size, arg)
      #Todo
    end

    def ufixed_encode(size, arg)
      #Todo
    end

    def byte_encode(size, arg)
      arg.map{ |b| b.to_s(16) }.join.rjust(size,'0')
    end

    def static_array(type, size, arg)
      #Todo
    end

    def dynamic_array(type, arg)
      #Todo
    end

    def address_encode(arg)
      uint_encode(160, arg)
    end

    def string_encode(arg)
      #Todo
    end

    def bytes_encode(arg)
      #Todo
    end

    def bool_encode(arg)
      #Todo
    end

  end

end
