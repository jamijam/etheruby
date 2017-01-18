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

    def to_s
      raise ArgumentsCountError.new("Bad number of arguments") unless args.count == params.count
      (0..params.count-1).map { |i|
        param, arg = params[i], args[i]
        Etheruby::treat_variable(param, arg, :encode)
      }.join
    end

  end

end
