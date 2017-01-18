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
    end

  end

end
