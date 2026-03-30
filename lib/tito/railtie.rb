module Tito
  class Railtie < Rails::Railtie
    initializer "tito.logger" do
      Tito.logger = Rails.logger
    end
  end
end
