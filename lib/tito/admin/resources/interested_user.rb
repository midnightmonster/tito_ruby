module Tito
  module Admin
    module Resources
      class InterestedUser < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/interested_users"
        resource_name "interested_user"
        collection_name "interested_users"
        supports :list, :show, :create, :update, :delete

        attribute :id,         :integer
        attribute :email,      :string
        attribute :name,       :string
        attribute :created_at, :datetime
        attribute :updated_at, :datetime
      end
    end
  end
end
