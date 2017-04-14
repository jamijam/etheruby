ETHER_MULTIPLES = {
  kwei: (10**3),
  mwei: (10**6),
  gwei: (10**9),
  szabo: (10**12),
  finney: (10**15),
  ether: (10**18),
  kether: (10**21),
  mether: (10**24),
  gether: (10**27),
  tether: (10**30)
}

module EtherMultipliable
  def method_missing(sym)
    if ETHER_MULTIPLES.has_key? sym
      return self * ETHER_MULTIPLES[sym]
    else
      raise NoMethodError.new
    end
  end

  def from_wei(sym)
    return self / ETHER_MULTIPLES[sym].to_f
  end
end

class Integer
  include EtherMultipliable
end

class Float
  include EtherMultipliable
end
