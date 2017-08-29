require 'singleton'

require_relative 'client'
require_relative 'contract_method_dsl'
require_relative 'arguments_generator'
require_relative 'response_parser'

module Etheruby::ContractBase

  class NoContractMethodError < StandardError; end
  class NoPasswordForAddress < StandardError; end

  module ClassMethods
    def contract_methods
      @c_methods ||= {}
    end

    def contract_method(name, &blk)
      cmd = Etheruby::ContractMethodDSL.new(name)
      cmd.instance_exec &blk if blk
      contract_methods[name] = cmd.validate!
    end

  end

  def at_address(address)
    address = address[2..64].to_i(16) if address.is_a? ::String
    @address = address
  end

  def contract_method(name, &blk)
    cmd = Etheruby::ContractMethodDSL.new(name)
    cmd.instance_exec &blk if blk
    @c_methods[name] = cmd.validate!
    @logger.debug("Registred method #{name}")
  end

  def to_camel_case(sym)
    ar = sym.to_s.split("_").map{|i| i.capitalize}
    ar[0] = ar.first.downcase
    ar.join.to_sym
  end

  def method_missing(sym, *args)
    unless self.class.contract_methods.include? sym
      sym = self.to_camel_case(sym)
    end
    raise NoContractMethodError.new (
                                      "The method #{sym} does not exist in the #{self.class.to_s} contract."
                                    ) unless self.class.contract_methods.include? sym
    execute_contract_method(self.class.contract_methods[sym], args)
  end

  def execute_contract_method(method_info, args)
    arguments = Etheruby::ArgumentsGenerator.new(method_info[:params], args).to_s
    data = "#{method_info[:signature]}#{arguments}"
    composed_body = { to: self.address, data: data }

    [ :gas, :gasPrice, :value, :from ].each { |kw|
      composed_body[kw] = method_info[kw] if method_info.has_key? kw
    }

    @logger.debug("Calling #{method_info[:name]} with parameters #{composed_body.inspect}")

    response = if method_info.has_key?(:force_transac) and method_info[:force_transac]
      do_eth_transaction composed_body
    else
      call_api composed_body
    end

    if response.is_a? Hash and response.has_key? 'error'
      @logger.error("Failed contract execution #{response['error']['message']}")
    elsif response.is_a? Hash and response.has_key? 'result'
      @logger.debug("Response from API for #{method_info[:name]} : #{response.inspect}")
      if method_info.has_key? :returns
        Etheruby::ResponseParser.new(method_info[:returns], response['result']).parse
      else
        response['result']
      end
    else
      @logger.error("Failed contract execution response : #{response.inspect}")
    end
  end

  def call_api(composed_body)
    if composed_body.has_key? :gas or composed_body.has_key? :value
      return do_eth_transaction(composed_body)
    else
      return do_eth_call(composed_body)
    end
  end

  def do_eth_call(composed_body)
    Etheruby::Client.eth.call(
      composed_body,
      Etheruby::Configuration.default_height || "latest"
    )
  end

  def do_eth_transaction(composed_body)
    from_address = composed_body[:from] || Etheruby::Configuration.default_from
    pwd = Etheruby::Configuration.addresses[from_address]
    composed_body[:from] = address_fix(from_address)
    Etheruby::Client.personal.sendTransaction(composed_body, pwd)
  end

  def address
    address_fix(@address)
  end

  def address_fix(addr)
    if addr.is_a? ::String
      addr
    else
      "0x#{addr.to_s(16).rjust(40, "0")}"
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end


end
