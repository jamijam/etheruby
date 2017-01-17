require 'logger'

require_relative 'etheruby/client'
require_relative 'etheruby/contract_method_dsl'
require_relative 'etheruby/arguments_generator'
require_relative 'etheruby/response_parser'

module Etheruby
  class NoContractMethodError < StandardError; end

  def contract
    Class.new do
      def self.inherited(subclass)
        @@c_methods = {}
        @@logger = ::Logger.new(STDOUT)
        @@logger.level = if ENV.has_key? 'ETHERUBY_DEBUG'
          ::Logger::DEBUG
        else
          ::Logger::WARN
        end
        @@logger.progname = "Etheruby Contract '#{subclass.name}'"
      end

      def self.at_address(address)
        @@address = address
      end

      def self.method(name, &blk)
        cmd = ContractMethodDSL.new(name)
        cmd.instance_exec &blk if blk
        @@c_methods[name] = cmd.validate!
        @@logger.debug("Registred method #{name}")
      end

      def self.method_missing(sym, *args)
        raise NoContractMethodError.new (
          "The method #{sym} does not exist in the #{self.class.to_s} contract."
        ) unless @@c_methods.include? sym
        execute_contract_method(@@c_methods[sym], args)
      end

      def self.execute_contract_method(method_info, args)
        arguments = ArgumentsGenerator.new(method_info[:params], args).to_s
        data = "#{method_info[:signature]}#{arguments}"
        composed_body = { to: self.address, data: data }
        [ :gas, :gasPrice, :value, :from ].each { |kw|
          composed_body[kw] = method_info[kw] if method_info.has_key? kw
        }
        @@logger.debug("Calling #{method_info[:name]} with parameters #{composed_body.inspect}")
        response = Client.eth.call composed_body, "latest"
        if response.has_key? 'error'
          @@logger.error("Failed contract execution #{response['error']['message']}")
        else
          @@logger.debug("Response from API for #{method_info[:name]} : #{response.inspect}")
        end
        if method_info.has_key? :returns
          ResponseParser.new(method_info[:returns], response['result']).parse
        else
          response['result']
        end
      end

      def self.address
        "0x#{@@address.to_s(16)}"
      end
    end
  end

  module_function :contract

  Contract = Etheruby::contract
end
