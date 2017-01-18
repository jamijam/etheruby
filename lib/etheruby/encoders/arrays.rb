require_relative 'base'
require_relative 'int'
require_relative '../treat_variable'

module Etheruby::Encoders

  class StaticArray < Base

    attr_reader :type, :size

    def initialize(_type, _size, _data)
      super(_data)
      @type = _type
      @size = _size
    end

    def encode
      data.map { |item| treat_variable(type, item, :encode) }.join
    end

    def decode

    end

  end

  class DynamicArray < Base

    attr_reader :type

    def initialize(_type, _data)
      super(_data)
      @type = _type
    end

    def encode
      Uint.new(data.count).encode + \
        StaticArray.new(type, data.count, data).encode
    end

    def decode

    end

  end

end
