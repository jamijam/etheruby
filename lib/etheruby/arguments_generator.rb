module Etheruby

  class IncorrectTypeError < StandardError; end
  class ArgumentsCountError < StandardError; end

  class ArgumentsGenerator

    attr_reader :params, :args

    def initialize(params, args)
      @params = params
      @args = args
    end

    def to_s
      raise ArgumentsCountError.new unless params.count == args.count
      arguments = ""
      (0..params.count-1).each do |i|
        param, arg = params[i], args[i]

        if match = param.match(/^([a-z]+)(\d+)$/)
          method_name = "#{match[1]}_encode".to_sym
          #puts method_name.inspect
          if respond_to?(method_name)
            arguments += send(method_name, match[2].to_i, arg)
          else
            raise IncorrectTypeError.new("Type #{param} cannot be encoded")
          end

        elsif match = param.match(/^([a-z]+)\[(\d+)\]$/)
          arguments += static_array(match[1], match[2].to_i, arg)

        elsif match = param.match(/^([a-z]+)\[\]$/)
          arguments += dynamic_array(match[1], arg)

        else
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

    def int_encode(size, arg)
      if arg >= 0
          arg.to_s(16).rjust(size / 4, '0')
      else
          mask = (1 << size) - 1
          (arg & mask).to_s(16)
      end
    end

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
      #Todo
    end

    def static_array(type, size, arg)
      #Todo
    end

    def dynamic_array(type, arg)
      #Todos
    end

    #====

    def address_encode(arg)
      #Todo
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
