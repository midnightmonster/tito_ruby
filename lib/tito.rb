require "faraday"
require "active_model"

module Tito
  require "tito/version"

  autoload :Configuration, "tito/configuration"
  autoload :Connection,    "tito/connection"
  autoload :Errors,        "tito/errors"
  autoload :Resource,      "tito/resource"

  module Types
    autoload :StringArray,  "tito/types/string_array"
    autoload :IntegerArray, "tito/types/integer_array"
    autoload :Json,         "tito/types/json"
  end

  module Admin
    autoload :Client,          "tito/admin/client"
    autoload :CollectionProxy, "tito/admin/collection_proxy"
    autoload :Scope,           "tito/admin/scope"
    autoload :QueryBuilder,    "tito/admin/query_builder"

    module Resources
      autoload :Event,              "tito/admin/resources/event"
      autoload :Release,            "tito/admin/resources/release"
      autoload :Ticket,             "tito/admin/resources/ticket"
      autoload :Registration,       "tito/admin/resources/registration"
      autoload :Activity,           "tito/admin/resources/activity"
      autoload :Question,           "tito/admin/resources/question"
      autoload :Answer,             "tito/admin/resources/answer"
      autoload :DiscountCode,       "tito/admin/resources/discount_code"
      autoload :CheckinList,        "tito/admin/resources/checkin_list"
      autoload :OptIn,              "tito/admin/resources/opt_in"
      autoload :InterestedUser,     "tito/admin/resources/interested_user"
      autoload :RsvpList,           "tito/admin/resources/rsvp_list"
      autoload :ReleaseInvitation,  "tito/admin/resources/release_invitation"
      autoload :WaitlistedPerson,   "tito/admin/resources/waitlisted_person"
      autoload :WebhookEndpoint,    "tito/admin/resources/webhook_endpoint"
      autoload :Refund,             "tito/admin/resources/refund"
      autoload :Venue,              "tito/admin/resources/venue"
    end
  end

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def logger
      configuration.logger
    end

    def logger=(logger)
      configuration.logger = logger
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

require "tito/railtie" if defined?(Rails::Railtie)

# Register custom types
ActiveModel::Type.register(:string_array, Tito::Types::StringArray)
ActiveModel::Type.register(:integer_array, Tito::Types::IntegerArray)
ActiveModel::Type.register(:json, Tito::Types::Json)
