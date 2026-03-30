module Tito
  class Connection
    attr_reader :base_url

    def initialize(token:, base_url: nil)
      @token = token
      @base_url = base_url || Tito.configuration.base_url
    end

    def get(path, params: {})
      handle_response faraday.get(path, params)
    end

    def post(path, body: {})
      handle_response faraday.post(path, body)
    end

    def patch(path, body: {})
      handle_response faraday.patch(path, body)
    end

    def delete(path)
      handle_response faraday.delete(path)
    end

    def faraday
      @faraday ||= Faraday.new(url: @base_url) do |f|
        f.headers["Authorization"] = "Token token=#{@token}"
        f.headers["Accept"] = "application/json"
        f.request :json
        f.response :logger, Tito.logger, headers: false, bodies: false if Tito.logger
        f.response :json, content_type: /\bjson$/
      end
    end

    private

    def handle_response(response)
      return response.body if response.success?
      raise Tito::Errors.from_response(response)
    end
  end
end
