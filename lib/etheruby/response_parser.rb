require_relative 'type_matchers'
require_relative 'treat_variable'
require_relative 'encoders/int'

module Etheruby

  class ResponseHolder
    def initialize(_values={})
      @values=_values
    end
    def method_missing(sym, *args)
      @values[sym]
    end
  end

  class ResponseParser

    attr_reader :returns, :response

    def initialize(_returns, _response)
      @returns = _returns
      @response = _response[2.._response.length]
    end

    def parse
      return unless @returns
      real_response = @response
      responses = {}
      i = 0
      loop do
        return_name, return_type = returns.keys[i], returns.values[i]
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
        if v.is_a? Etheruby::Encoders::DynamicArray or v.is_a? Etheruby::Encoders::StaticArray
          v, s = v.decode
        end
        responses[return_name] = v
        break if responses.count == returns.count
        real_response = real_response[s*2..real_response.length]
        i += 1
      end
      ResponseHolder.new(responses)
    end

  end

end
