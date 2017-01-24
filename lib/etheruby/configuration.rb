module Etheruby

  class Configuration

    def self.conf=(value)
      @@conf = value
    end

    def self.method_missing(sym, *arg)
      return @@conf[sym.to_s]
    end

  end

end
