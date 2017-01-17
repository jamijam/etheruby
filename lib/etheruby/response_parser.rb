require_relative 'type_matchers'

module Etheruby

  class ResponseParser

    def initialize(_returns, _response)
      @returns = _returns
      @response = _response
    end

    def treat_variable(param)
      if match = TypeMatchers.is_sized_type(param)
        # Parameter is a sized type, e.g. uint256, byte32 ...
        send("#{match[1]}_decode".to_sym, match[2].to_i)

      elsif match = TypeMatchers.is_dualsized_type(param)
        # Parameter is a dual sized array type, e.g. fixed16x16
        send("#{match[1]}_decode".to_sym, match[2].to_i, match[3].to_i)

      elsif match = TypeMatchers.is_static_array_type(param)
        # Parameter is a staticly sized array type, e.g. uint256[24]
        static_array_decode(match[1], match[2].to_i)

      elsif match = TypeMatchers.is_dynamic_array_type(param)
        # Parameter is a dynamicaly sized array type, e.g. uint256[]
        dynamic_array_decode(match[1])

      else
        # Parameter is a single-word type : string, bytes, address etc...
        send("#{param}_decode".to_sym)

      end
    end

    def parse
      if @returns.count == 1
        treat_variable(@returns[0])
      else
        @returns.map { |type| treat_variable(type) }
      end
    end

    # Each decode method will receive in parameters the response string remaining
    # to parse. It will extract the type of the response considering it as the
    # first thing in the string and returns the string without it. Doing this,
    # method calls will be chainable easily.

    ##
    # int<X> decoding
    def int_decode(size)
    end

    ##
    # uint<X> decoding
    def uint_decode(size)
      v, @response = @response[0..(size/4)].to_i(16), 
                     @response[(size/4)..@response.length]
      v
    end

    ##
    # ufixed<X> decoding
    def ufixed_decode(size_i, size_d)
    end

    ##
    # fixed<X> decoding
    def fixed_decode(size_i, size_d)
    end

    ##
    # Decodes a static array
    def static_array_decode(type, size)
    end

    ##
    # Decodes a dynamic array
    def dynamic_array_decode(type)
    end

    ##
    # byte<X> decoding
    def byte_decode(size)
    end

    ##
    # address<X> decoding
    def address_decode
    end

    ##
    # string<x> decoding (as bytes)
    def string_decode
    end

    ##
    # bytes (dynamic size) decoding
    def bytes_decode
    end

    ##
    # boolean decoding (as uint8)
    def bool_decode
      uint_decode(8) == 1
    end

  end

end
