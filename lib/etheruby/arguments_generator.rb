module Etheruby

  class ArgumentsCountError < StandardError; end

  class ArgumentsGenerator

    attr_reader :params, :args

    def initialize(params, args)
      @params = params
      @args = args
    end

    def to_s
      raise ArgumentsCountError.new unless params.count == args.count
      arguments = ""
      (0..params.count-1).each do |i|
        param, arg = params[i], args[i]
        if match = param.match(/^int(\d+)$/)
          arguments += integer_encode(match[1].to_i / 4, arg)
        # elsif match = param.match(/^uint(\d+)$/)
        # How to do ?
        end
      end
      arguments
    end

    private

      def integer_encode(size, arg)
        arg.to_s(16).rjust(size,'0')
      end

  end

end
