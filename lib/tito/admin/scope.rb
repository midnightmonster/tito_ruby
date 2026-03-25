module Tito
  module Admin
    class Scope
      attr_reader :client, :account, :event, :resource_class, :parent_id

      def initialize(client:, account:, event: nil, resource_class:, parent_id: nil)
        @client = client
        @account = account
        @event = event
        @resource_class = resource_class
        @parent_id = parent_id
        validate!
      end

      def connection
        client.connection
      end

      def collection_path(suffix: nil)
        base = interpolate(resource_class.path_template)
        suffix ? "#{base}#{suffix}" : base
      end

      def member_path(id_or_slug)
        if resource_class.member_path_template
          interpolate(resource_class.member_path_template, id_or_slug: id_or_slug)
        else
          "#{collection_path}/#{id_or_slug}"
        end
      end

      def nested_scope(child_class, parent_id:)
        self.class.new(
          client: client,
          account: account,
          event: event,
          resource_class: child_class,
          parent_id: parent_id
        )
      end

      def request(method, path, params: {}, body: {})
        case method
        when :get    then connection.get(path, params: params)
        when :post   then connection.post(path, body: body)
        when :patch  then connection.patch(path, body: body)
        when :delete then connection.delete(path)
        end
      end

      private

      def interpolate(template, id_or_slug: nil)
        result = template.dup
        result.gsub!("%{account}", account.to_s)
        result.gsub!("%{event}", event.to_s) if event
        result.gsub!("%{parent_id}", parent_id.to_s) if parent_id
        result.gsub!("%{id_or_slug}", id_or_slug.to_s) if id_or_slug
        result
      end

      def validate!
        raise Tito::Errors::ConfigurationError, "account is required" unless account
        if resource_class.event_scoped? && event.nil?
          raise Tito::Errors::ConfigurationError,
            "event is required for #{resource_class.resource_name} resources"
        end
      end
    end
  end
end
