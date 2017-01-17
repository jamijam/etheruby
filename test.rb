#!/usr/bin/env ruby

require 'bigdecimal'

def decimal_representation(precision, value)
  (0..precision-1).map {
    int_part, value = (value*2).to_i, (value*2) - (value*2).to_i
    int_part
  }.each_slice(8).map { |slice|
    slice.join.to_i(2).to_s(16).ljust(2,'0')
  }.join
end

# int<X> encoding
def int_encode(size, arg)
  if arg >= 0
      arg.to_s(16).rjust(size / 4, '0')
  else
      mask = (1 << size) - 1
      (arg & mask).to_s(16)
  end
end

##
# fixed<X>
def fixed_encode(size_i, size_d, arg)
  raise InvalidFormatForDataError.new("Please use BigDecimal !") unless arg.is_a? BigDecimal
  if arg >= 0
    int_part, dec_part = arg.to_i, arg - arg.to_i
  else
    int_part, dec_part = arg.to_i, (arg + arg.to_i).abs
  end
  int_encode(size_i, int_part) + \
  decimal_representation(size_d, dec_part)
end

puts fixed_encode(8,80,BigDecimal("15.34"))
