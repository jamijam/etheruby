Dir["./app/contracts/**/*.rb"].each { |f| require f }

require 'yaml'

module Etheruby

  class Railtie < Rails::Railtie
    # Loads configuration
    initializer "etheruby.configure" do |app|
      Etheruby::Configuration.conf = if File.exist? './config/etheruby.yml'
        YAML.load_file('./config/etheruby.yml')
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
