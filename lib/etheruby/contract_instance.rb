require_relative 'client'
require_relative 'contract_method_dsl'
require_relative 'arguments_generator'
require_relative 'response_parser'
require_relative 'contract_base'

module Etheruby::ContractInstance

  def self.included(base)
    base.include(Etheruby::ContractBase)
  end

  def initialize(address)
    @address = at_address(address)
    @logger = ::Logger.new(STDOUT)
    @logger.level = if ENV.has_key? 'ETHERUBY_DEBUG'
      ::Logger::DEBUG
    else
      ::Logger::WARN
    end
    @logger.progname = "Etheruby Contract '#{self.class.name}'"
  end


end
