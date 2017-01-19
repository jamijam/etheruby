module Etheruby

  class Railtie < Rails::Railtie
    initializer "etheruby.configure" do |app|
      Etheruby::Client.uri = app.config.etheruby_uri if app.config.respond_to? :etheruby_uri
    end
  end

end
