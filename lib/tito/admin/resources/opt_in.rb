module Tito
  module Admin
    module Resources
      class OptIn < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/opt_ins"
        resource_name "opt_in"
        collection_name "opt_ins"
        supports :list, :show, :create, :update, :delete

        attribute :id,               :integer
        attribute :slug,             :string
        attribute :name,             :string
        attribute :description,      :string
        attribute :acceptance_count, :integer
        attribute :created_at,       :datetime
        attribute :updated_at,       :datetime

        expandable :releases
      end
    end
  end
end
