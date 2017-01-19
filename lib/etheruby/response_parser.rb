require_relative 'type_matchers'

module Etheruby

  class ResponseParser

    attr_reader :returns, :response

    def initialize(_returns, _response)
      @returns = _returns
      @response = _response[2.._response.length]
    end

    def parse
      if returns.count == 1
        Etheruby::treat_variable(returns[0], response, :decode)
      else
        raise NotImplementedError.new("Multiple returns are not yet supported")
      end
    end

  end

end
