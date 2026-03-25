module Tito
  module Errors
    class Error < StandardError; end
    class ConfigurationError < Error; end

    class ApiError < Error
      attr_reader :status, :body, :errors

      def initialize(message = nil, status: nil, body: nil)
        @status = status
        @body = body
        @errors = body.is_a?(Hash) ? (body["errors"] || {}) : {}
        super(message || (body.is_a?(Hash) && body["message"]) || "API error (#{status})")
      end
    end

    class UnauthorizedError < ApiError; end  # 401
    class ForbiddenError    < ApiError; end  # 403
    class NotFoundError     < ApiError; end  # 404
    class ValidationError   < ApiError; end  # 422
    class RateLimitError    < ApiError; end  # 429
    class ServerError       < ApiError; end  # 5xx

    MAPPING = {
      401 => UnauthorizedError,
      403 => ForbiddenError,
      404 => NotFoundError,
      422 => ValidationError,
      429 => RateLimitError
    }.freeze

    def self.from_response(response)
      status = response.status
      body = response.body

      klass = MAPPING[status] || (status >= 500 ? ServerError : ApiError)
      klass.new(status: status, body: body)
    end
  end
end
