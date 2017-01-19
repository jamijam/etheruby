require_relative 'type_matchers'
require_relative 'treat_variable'
require_relative 'encoders/int'

module Etheruby

  class ResponseParser

    attr_reader :returns, :response

    def initialize(_returns, _response)
      @returns = _returns
      @response = _response[2.._response.length]
    end

    def parse
      if returns.count == 1
        v, s = Etheruby::treat_variable(returns[0], response, :decode)
        v = v.decode if v.is_a? Etheruby::Encoders::DynamicArray or v.is_a? Etheruby::Encoders::StaticArray
        v
      else
        real_response = @response
        values = []
        i = 0
        loop do
          return_type = returns[i]
          if Etheruby::is_static_type?(return_type)
            v, s = Etheruby::treat_variable(return_type, real_response, :decode)
          else
            value_position, s = Etheruby::Encoders::Uint.new(real_response).decode
            v, take_size = Etheruby::treat_variable(
              return_type,
              @response[(value_position*2)..response.length],
              :decode
            )
          end
          v = v.decode if v.is_a? Etheruby::Encoders::DynamicArray or v.is_a? Etheruby::Encoders::StaticArray
          values << v
          break if values.count == returns.count
          real_response = real_response[s*2..real_response.length]
          i += 1
        end
        values
      end
    end

  end

end
