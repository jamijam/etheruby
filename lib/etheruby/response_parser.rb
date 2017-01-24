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
      @returns = if _returns.is_a? ::String or _returns.is_a? ::Symbol
        [_returns]
      else
        _returns
      end
      @response = _response[2.._response.length]
    end

    def parse
      return unless @returns
      real_response = @response
      responses = if @returns.is_a? Array
        []
      else
        {}
      end
      i = 0

      loop do
        if @returns.is_a? ::Hash
          return_name, return_type = returns.keys[i], returns.values[i]
        else
          return_type = returns[i]
        end

        # Treat element
        if Etheruby::is_static_type? return_type
          v, s = Etheruby::treat_variable return_type, real_response, :decode
        else
          value_position, s = Etheruby::Encoders::Uint.new(real_response).decode
          v, take_size = Etheruby::treat_variable(
            return_type,
            @response[(value_position*2)..response.length],
            :decode
          )
        end

        # Treat arrays
        if v.is_a? Etheruby::Encoders::DynamicArray or
           v.is_a? Etheruby::Encoders::StaticArray
          v, s = v.decode
        end

        # Add response to responses array
        if returns.is_a? ::Hash
          responses[return_name] = v
        else
          responses << v
        end

        # Continues until it has the good number of response
        break if responses.count == returns.count
        real_response = real_response[s*2..real_response.length]
        i += 1
      end

      # Returning response in the appropriate format
      if @returns.is_a? ::Hash
        ResponseHolder.new responses
      else
        if @returns.count == 1
          responses[0]
        else
          responses
        end
      end

    end
  end
end
