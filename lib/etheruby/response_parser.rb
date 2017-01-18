require_relative 'type_matchers'

module Etheruby

  class ResponseParser

    attr_reader :returns, :response

    def initialize(_returns, _response)
      @returns = _returns
      @response = _response
    end

    def parse
      if returns.count == 1
        Etheruby::treat_variable(returns[0], response)
      else
        returns.each do |type|
          
        end
      end
    end

  end

end
