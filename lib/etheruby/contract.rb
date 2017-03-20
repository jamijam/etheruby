require_relative 'client'
require_relative 'contract_method_dsl'
require_relative 'arguments_generator'
require_relative 'response_parser'

module Etheruby
  class NoContractMethodError < StandardError; end
  class NoPasswordForAddress < StandardError; end

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
        address = address[2..64].to_i(16) if address.is_a? ::String
        @@address = address
      end

      def self.method(name, &blk)
        cmd = ContractMethodDSL.new(name)
        cmd.instance_exec &blk if blk
        @@c_methods[name] = cmd.validate!
        @@logger.debug("Registred method #{name}")
      end

      def self.to_camel_case(sym)
        ar = sym.to_s.split("_").map{|i| i.capitalize}
        ar[0] = ar.first.downcase
        ar.join.to_sym
      end

      def self.method_missing(sym, *args)
        unless @@c_methods.include? sym
          sym = self.to_camel_case(sym)
        end
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

        response = if method_info.has_key?(:force_transac) and method_info[:force_transac]
          do_eth_transaction composed_body
        else
          call_api composed_body
        end

        if response.is_a? Hash and response.has_key? 'error'
          @@logger.error("Failed contract execution #{response['error']['message']}")
        elsif response.is_a? Hash and response.has_key? 'result'
          @@logger.debug("Response from API for #{method_info[:name]} : #{response.inspect}")
          if method_info.has_key? :returns
            ResponseParser.new(method_info[:returns], response['result']).parse
          else
            response['result']
          end
        else
          @@logger.error("Failed contract execution response : #{response.inspect}")
        end
      end

      def self.call_api(composed_body)
        if composed_body.has_key? :gas or composed_body.has_key? :value
          return do_eth_transaction(composed_body)
        else
          return do_eth_call(composed_body)
        end
      end

      def self.do_eth_call(composed_body)
        Client.eth.call(composed_body, Configuration.default_height || "latest")
      end

      def self.do_eth_transaction(composed_body)
        from_address = composed_body[:from] || Configuration.default_from
        pwd = Configuration.addresses[from_address]
        composed_body[:from] = address_fix(from_address)
        Client.personal.sendTransaction(composed_body, pwd)
      end

      def self.address
        address_fix(@@address)
      end

      def self.address_fix(addr)
        if addr.is_a? ::String
          addr
        else
          "0x#{addr.to_s(16)}"
        end
      end
    end
  end

  module_function :contract

  Contract = Etheruby::contract
end
