require_relative 'encoders/address'
require_relative 'encoders/arrays'
require_relative 'encoders/bool'
require_relative 'encoders/bytes'
require_relative 'encoders/fixed'
require_relative 'encoders/int'
require_relative 'encoders/string'
require_relative 'type_matchers'

module Etheruby

  def is_static_type?(param)
    !(%w(string bytes).include?(param.to_s) || TypeMatchers.is_dynamic_array_type(param))
  end

  def is_array?(param)
    TypeMatchers.is_static_array_type(param) || TypeMatchers.is_dynamic_array_type(param)
  end

  def treat_variable(param, arg, direction)
    if match = TypeMatchers.is_sized_type(param)
      # Parameter is a sized type, e.g. uint256, byte32 ...
      klass = Etheruby::Encoders.const_get(match[1].capitalize)
      return case klass
      when Encoders::Bytes
        Byte.new(match[2].to_i, arg)
      else
        klass.new(arg)
      end.send(direction)

    elsif match = TypeMatchers.is_dualsized_type(param)
      # Parameter is a dual sized array type, e.g. fixed16x16, ufixed128x128
      return Etheruby::Encoders.const_get(match[1].capitalize).
             new(match[2].to_i, match[3].to_i, arg).send(direction)

    elsif match = TypeMatchers.is_static_array_type(param)
      # Parameter is a staticly sized array type, e.g. uint256[24]
      Etheruby::Encoders::StaticArray.new(match[1], match[2].to_i, arg)

    elsif match = TypeMatchers.is_dynamic_array_type(param)
      # Parameter is a dynamicaly sized array type, e.g. uint256[]
      Etheruby::Encoders::DynamicArray.new(match[1], arg).send(direction)

    else
      # Parameter is a single-word type : string, bytes, address etc...
      Etheruby::Encoders.const_get(param.capitalize).new(arg).send(direction)

    end
  end

  module_function :treat_variable, :is_static_type?, :is_array?
end
