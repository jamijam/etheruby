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
      if @returns.count == 1
        treat_variable(@returns[0], @response)[0]
      else
        @returns.map { |type|
          value, @response = treat_variable(type, @response)
          value
        }
      end
    end

    # Each decode method will receive in parameters the response string remaining
    # to parse. It will extract the type of the response considering it as the
    # first thing in the string and returns the string without it. Doing this,
    # method calls will be chainable easily.

    ##
    # int<X> decoding
    def int_decode(size, arg)
      to_parse = arg[0..(size/4)-1]
      arg = arg[(size/4)..@response.length]
      in_int = to_parse.to_i(16)
      in_bin = in_int.to_s(2).rjust(size, '0')
      value = if in_bin[0] == '1'
        -(in_bin.split("").map{ |i| i == '1' ? '0' : '1' }.join.to_i(2) + 1)
      else
        to_parse.to_i(16)
      end
      return value, arg
    end

    ##
    # uint<X> decoding
    def uint_decode(size, arg)
      return arg[0..(size/4)-1].to_i(16), arg[(size/4)..arg.length]
    end

    ##
    # ufixed<X> decoding
    def ufixed_decode(size_i, size_d, arg)

    end

    ##
    # fixed<X> decoding
    def fixed_decode(size_i, size_d, arg)
      
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

    ##
    # byte<X> decoding
    def byte_decode(size, arg)
      return (0..size-1).map { |i|
        value = arg[0..1].to_i(16)
        arg = arg[2..arg.length]
        value
      }, arg
    end

    ##
    # address<X> decoding
    def address_decode(arg)
      return "0x#{arg[0..39]}", arg[40..arg.length]
    end

    ##
    # string<x> decoding (as bytes)
    def string_decode(arg)
      value, arg = bytes_decode(arg)
      return value.pack('U*'), arg
    end

    ##
    # bytes (dynamic size) decoding
    def bytes_decode(arg)
      size, arg = uint_decode(256, arg)
      return byte_decode(size, arg)
    end

    ##
    # boolean decoding (as uint8)
    def bool_decode(arg)
      value, arg = uint_decode(8, arg)
      return value == 1, arg
    end

  end

end
