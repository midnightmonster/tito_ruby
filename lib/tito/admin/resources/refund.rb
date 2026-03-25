module Tito
  module Admin
    module Resources
      class Refund < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/registrations/%{parent_id}/refunds"
        resource_name "refund"
        collection_name "refunds"
        supports :list, :show

        attribute :id,         :integer
        attribute :amount,     :decimal
        attribute :manual,     :boolean
        attribute :created_at, :datetime

        expandable :registration
      end
    end
  end
end
