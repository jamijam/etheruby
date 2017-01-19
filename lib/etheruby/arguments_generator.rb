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
      head = []
      tail = ''
      current_tail_position = 0
      (0..params.count-1).each do |i|
        param, arg = params[i], args[i]
        if Etheruby.is_static_type? param
          head << {final: Etheruby.treat_variable(param, arg, :encode).to_s}
        else
          head << {pointer: current_tail_position}
          content = Etheruby.treat_variable(param, arg, :encode).to_s
          current_tail_position += content.length/2
          tail += content
        end
      end
      head_size = head.map { |x|
        if x.has_key?(:pointer)
          32
        else
          x[:final].length/2
        end
      }.inject(0){|sum,x| sum + x }
      final_head = head.map { |x|
        if x.has_key?(:pointer)
          Etheruby::Encoders::Uint.new(head_size + x[:pointer]).encode
        else
          x[:final]
        end
      }.join
      return final_head + tail
    end

  end

end
