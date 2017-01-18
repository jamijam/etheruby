module Etheruby

  module Encoders

    class IncorrectTypeError < StandardError; end
    class InvalidFormatForDataError < StandardError; end

    class Base
      attr_reader :data

      def initialize(_data)
        @data = _data
      end

      protected

        def determinate_closest_padding(size)
          if size % 32 == 0
            size
          else
            32*(size/32+1)
          end
        end
    end

  end

end
