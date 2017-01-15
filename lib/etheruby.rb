require_relative 'etheruby/client'
require_relative 'etheruby/contract_method_dsl'
require_relative 'etheruby/arguments_generator'

module Etheruby

  class NoContractMethodError < StandardError; end

  class Contract

    @@c_methods = {}

    def self.at_address(address)
      @@address = address
    end

    def self.method(name, &blk)
      cmd = ContractMethodDSL.new(name)
      cmd.instance_exec &blk if blk
      @@c_methods[name] = cmd.validate!
    end

    def self.method_missing(sym, *args)
      raise NoContractMethodError.new (
        "The method #{sym} does not exist in the #{self.class.to_s} contract."
      ) unless @@c_methods.include? sym
      execute_contract_method(@@c_methods[sym], args)
    end

    private

      # Check : https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
      def self.execute_contract_method(method_info, args)
        arguments = ArgumentsGenerator.new(method_info[:params], args).to_s
        puts "Data to send : #{method_info[:signature]}#{arguments}"
      end

  end

end
