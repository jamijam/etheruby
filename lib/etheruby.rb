require 'bundler/setup'
require 'logger'
require_relative 'etheruby/client'
require_relative 'etheruby/contract'
require_relative 'etheruby/ether_multipliable'
require_relative 'etheruby/configuration'
require_relative 'etheruby/railtie' if defined?(Rails)
