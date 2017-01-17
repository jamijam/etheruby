module Etheruby

  class ResponseParser

    attr_reader :returns, :response

    def initialize(returns, response)
      @returns = returns
      @response = response
    end

    def parse
    end

  end

end
