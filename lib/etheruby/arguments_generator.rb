require 'bigdecimal'
require_relative 'type_matchers'

module Etheruby

  class ArgumentsCountError < StandardError; end

  class ArgumentsGenerator

    attr_reader :params, :args

    def initialize(params, args)
      @params = params
      @args = args
    end

    ##
    # Encode a static array
    def static_array_encode(type, size, arg)
      raise InvalidFormatForDataError.new(
        "Array have #{arg.count} items for #{size} sized variable"
      ) unless arg.count == size
      arg.map { |item| treat_variable(type, item) }.join
    end

    ##
    # Creates a dynamic array
    def dynamic_array_encode(type, arg)
      static_array_encode(type, arg.count, arg)
    end

  end

end
