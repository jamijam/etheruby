require 'bigdecimal'
require_relative 'type_matchers'
require_relative 'treat_variable'
require_relative 'encoders/int'

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
      head = ''
      tail = ''
      current_tail_position = (params.count*32)
      (0..params.count-1).each do |i|
        param, arg = params[i], args[i]
        if Etheruby.is_static_type? param
          head += Etheruby.treat_variable(param, arg, :encode).to_s
        else
          head += Etheruby::Encoders::Uint.new(current_tail_position).encode
          content = Etheruby.treat_variable(param, arg, :encode).to_s
          current_tail_position += content.length/2
          tail += content
        end
      end
      return head + tail
    end

  end

end
