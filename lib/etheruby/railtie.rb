Dir["./app/contracts/**/*.rb"].each { |f| require f }

module Etheruby

  class Railtie < Rails::Railtie
    initializer "etheruby.configure" do |app|
      if app.config.respond_to? :etheruby_uri
        Etheruby::Client.uri = app.config.etheruby_uri
      end

      if app.config.respond_to? :etheruby_enable_transactions
        Etheruby::TransactionInformation.information = \
          app.config.etheruby_enable_transactions
      end
    end
  end

end
