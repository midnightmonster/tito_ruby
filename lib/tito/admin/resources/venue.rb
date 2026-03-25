module Tito
  module Admin
    module Resources
      class Venue < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/venues"
        resource_name "venue"
        collection_name "venues"
        supports :list, :show, :create, :update, :delete

        attribute :id,         :integer
        attribute :name,       :string
        attribute :address,    :string
        attribute :created_at, :datetime
        attribute :updated_at, :datetime
      end
    end
  end
end
