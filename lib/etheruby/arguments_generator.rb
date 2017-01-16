module Etheruby

  class IncorrectTypeError < StandardError; end
  class ArgumentsCountError < StandardError; end
  class InvalidFormatForDataError < StandardError; end

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

    def is_dualsized_type(param)
      param.to_s.match /^(.+)(\d+)x(\d+)$/
    end

    def is_static_array_type(param)
      param.to_s.match(/^(.+)\[(\d+)\]$/)
    end

    def is_dynamic_array_type(param)
      param.to_s.match(/^(.+)\[\]$/)
    end

    def treat_variable(param, arg)
      if match = is_sized_type(param)
        # Parameter is a sized type, e.g. uint256, byte32 ...
        send("#{match[1]}_encode".to_sym, match[2].to_i, arg)
      elsif match = is_dualsized_type(param)
        # Parameter is a dual sized array type, e.g. fixed16x16
        send("#{match[1]}_encode".to_sym, match[2].to_i, match[3].to_i, arg)
      elsif match = is_static_array_type(param)
        # Parameter is a staticly sized array type, e.g. uint256[24]
        static_array(match[1], match[2].to_i, arg)
      elsif match = is_dynamic_array_type(param)
        # Parameter is a dynamicaly sized array type, e.g. uint256[]
        dynamic_array(match[1], arg)
      else
        # Parameter is a single-word type : string, bytes, address etc...
        send("#{param}_encode".to_sym, arg)
      end
    end

    def to_s
      raise ArgumentsCountError.new unless params.count == args.count
      # For each parameter of the method called, we
      # match the corresponding type to encode and we send the
      # parameter given to this encoder
      (0..params.count-1).map { |i| treat_variable(params[i], args[i]) }.join
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
      raise InvalidFormatForDataError.new("unsigned integer #{arg} < 0") if arg < 0
      int_encode(size,arg)
    end

    ##
    # fixed<X>
    def fixed_encode(size_i, size_d, arg)
      int_part, dec_part = arg.to_i, arg - arg.to_i
      int_encode(size_i, int_part) + decimal_representation(size_d, dec_part)
    end

    ##
    # Represent the decimal part in hexadimal according to the precision
    def decimal_representation(precision, value)
      ""
      # ToDo : Check how to do this ?
    end

    ##
    # ufixed<X> encoding
    def ufixed_encode(size_i, size_d, arg)
      raise InvalidFormatForDataError.new("unsigned fixed #{arg} < 0") if arg < 0
      fixed_encode(size_i, size_d, arg)
    end

    ##
    # Encode a static array
    def static_array(type, size, arg)
      raise InvalidFormatForDataError.new(
        "Array have #{arg.count} items for #{size} sized variable"
      ) unless arg.count == size
      arg.map { |item| treat_variable(type, item) }.join
    end

    ##
    # Creates a dynamic array
    def dynamic_array(type, arg)
      uint_encode(256, arg.count) + static_array(type, arg.count, arg)
    end

    ##
    # byte<X> encodeing
    def byte_encode(size, arg)
      arg.map{ |b| b.to_s(16).rjust(2,'0') }.join.rjust(size,'0')
    end

    ##
    # address<X> encoding
    def address_encode(arg)
      uint_encode(160, arg)
    end

    ##
    # string<x> encoding (as bytes)
    def string_encode(arg)
      bytes_encode(arg.codepoints)
    end

    ##
    # bytes (dynamic size) encoding
    def bytes_encode(arg)
      uint_encode(256, arg.count) + arg.map{ |b| b.to_s(16).rjust(2,'0') }.join
    end

    ##
    # boolean encoding (as uint8)
    def bool_encode(arg)
      uint_encode(8, arg ? 1 : 0)
    end

  end

end
