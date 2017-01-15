require 'digest/sha3'

module Etheruby

  # Defining the allowed types for parameters
  CONTRACT_TYPES = [ :bool, :address, :string, :bytes] +
  (8..256).step(8).flat_map { |i| [ "uint#{i}".to_sym, "int#{i}".to_sym  ] } +
  (1..32).map { |i| "byte#{i}".to_sym }

  # Error raised when a type is not in CONTRACT_TYPES
  class IncorrectType < StandardError; end

  # The micro-dsl to describe a method on a contract
  class ContractMethodDSL

    attr_reader :data

    def initialize(name)
      @data = { name: name }
    end

    def parameters(*args)
      check_args(args)
      data[:params] = args
    end

    def returns(*args)
      check_args(args)
      data[:returns] = args
    end

    def method_missing(sym, *args)
      data[sym] = args[0]
    end

    def validate!
      data[:params] = [] unless data.has_key? :params
      signature = "#{@data[:name]}(#{data[:params].join(',')})"
      # Generating the signature of this method
      data[:signature] = "0x#{Digest::SHA3.hexdigest(signature,256)[0..7]}"
      data
    end

    private

      def check_args(args)
        args.each do |arg|
          raise IncorrectType.new("Type #{arg} does not exist !") unless CONTRACT_TYPES.include? arg
        end
      end

  end

end
