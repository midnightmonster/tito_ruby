module Tito
  class Configuration
    attr_accessor :token, :account, :base_url, :logger

    def initialize
      @base_url = "https://api.tito.io/v3"
    end
  end
end
