require_relative 'type_matchers'

module Etheruby

  class ResponseParser

    def initialize(_returns, _response)
      @returns = _returns
      @response = _response
    end

    def treat_variable(param, arg)
      if match = TypeMatchers.is_sized_type(param)
        # Parameter is a sized type, e.g. uint256, byte32 ...
        send("#{match[1]}_decode".to_sym, match[2].to_i, arg)

      elsif match = TypeMatchers.is_dualsized_type(param)
        # Parameter is a dual sized array type, e.g. fixed16x16
        send("#{match[1]}_decode".to_sym, match[2].to_i, match[3].to_i, arg)

      elsif match = TypeMatchers.is_static_array_type(param)
        # Parameter is a staticly sized array type, e.g. uint256[24]
        static_array_decode(match[1], match[2].to_i, arg)

      elsif match = TypeMatchers.is_dynamic_array_type(param)
        # Parameter is a dynamicaly sized array type, e.g. uint256[]
        dynamic_array_decode(match[1], arg)

      else
        # Parameter is a single-word type : string, bytes, address etc...
        send("#{param}_decode".to_sym, arg)

      end
    end

    def parse
      #
    end

    ##
    # Decodes a static array
    def static_array_decode(type, size, arg)
      return (0..size-1).map {
        value, arg = treat_variable(type, arg)
        value
      }, arg
    end

    ##
    # Decodes a dynamic array
    def dynamic_array_decode(type, arg)
      size, arg = uint_decode(256, arg)
      return static_array_decode(type, size, arg)
    end


  end

end
