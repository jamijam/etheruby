Dir["./app/contracts/**/*.rb"].each { |f| require f }

require 'yaml'

module Etheruby

  class Railtie < Rails::Railtie
    # Loads configuration
    initializer "etheruby.configure" do |app|
      Etheruby::Configuration.conf = if File.exist? './config/etheruby.yml'
        YAML.load(ERB.new(File.read("./config/etheruby.yml")).result).with_indifferent_access
      else
        {}
      end
    end

    # Create setup rake task
    rake_tasks do
      load File.join(File.dirname(__FILE__), '../../tasks/etheruby/setup.task')
    end
  end

end
