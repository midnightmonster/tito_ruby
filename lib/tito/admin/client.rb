module Tito
  module Admin
    class Client
      attr_reader :token, :account, :event, :connection

      def initialize(token: nil, account: nil, event: nil)
        @token   = token   || Tito.configuration.token
        @account = account || Tito.configuration.account
        @event   = event

        raise Tito::Errors::ConfigurationError, "token is required" unless @token
        raise Tito::Errors::ConfigurationError, "account is required" unless @account

        @connection = Tito::Connection.new(token: @token)
      end

      # -- Account-scoped resources --

      def events
        collection_for(Resources::Event)
      end

      def past_events
        collection_for(Resources::Event, path_suffix: "/past")
      end

      def archived_events
        collection_for(Resources::Event, path_suffix: "/archived")
      end

      def webhook_endpoints
        collection_for(Resources::WebhookEndpoint)
      end

      # -- Event-scoped resources --

      def tickets(event: self.event)
        collection_for(Resources::Ticket, event: event)
      end

      def releases(event: self.event)
        collection_for(Resources::Release, event: event)
      end

      def registrations(event: self.event)
        collection_for(Resources::Registration, event: event)
      end

      def activities(event: self.event)
        collection_for(Resources::Activity, event: event)
      end

      def questions(event: self.event)
        collection_for(Resources::Question, event: event)
      end

      def discount_codes(event: self.event)
        collection_for(Resources::DiscountCode, event: event)
      end

      def checkin_lists(event: self.event)
        collection_for(Resources::CheckinList, event: event)
      end

      def opt_ins(event: self.event)
        collection_for(Resources::OptIn, event: event)
      end

      def interested_users(event: self.event)
        collection_for(Resources::InterestedUser, event: event)
      end

      def rsvp_lists(event: self.event)
        collection_for(Resources::RsvpList, event: event)
      end

      def waitlisted_people(event: self.event)
        collection_for(Resources::WaitlistedPerson, event: event)
      end

      def venues(event: self.event)
        collection_for(Resources::Venue, event: event)
      end

      private

      def collection_for(resource_class, event: nil, path_suffix: nil)
        scope = Scope.new(
          client: self,
          account: @account,
          event: event,
          resource_class: resource_class
        )
        CollectionProxy.new(scope: scope, path_suffix: path_suffix)
      end
    end
  end
end
