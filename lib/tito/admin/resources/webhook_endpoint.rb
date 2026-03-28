module Tito
  module Admin
    module Resources
      class WebhookEndpoint < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/webhook_endpoints"
        resource_name "webhook_endpoint"
        collection_name "webhook_endpoints"
        supports :list, :show, :create, :update, :delete

        attribute :id,                 :integer
        attribute :url,                :string
        attribute :status,             :string
        attribute :included_triggers,  :string_array
        attribute :custom_data,        :json
        attribute :deprecated,         :boolean
        attribute :created_at,         :datetime
        attribute :updated_at,         :datetime
      end
    end
  end
end
