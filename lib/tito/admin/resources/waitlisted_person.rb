module Tito
  module Admin
    module Resources
      class WaitlistedPerson < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/waitlisted_people"
        resource_name "waitlisted_person"
        collection_name "waitlisted_people"
        supports :list, :show, :create, :update, :delete

        attribute :id,               :integer
        attribute :release_id,       :integer
        attribute :name,             :string
        attribute :email,            :string
        attribute :state,            :string
        attribute :status,           :string
        attribute :offered_at,       :datetime
        attribute :offered,          :boolean
        attribute :expires_at,       :datetime
        attribute :expired,          :boolean
        attribute :unique_offer_url, :string
        attribute :joined_at,        :datetime
        attribute :joined,           :boolean
        attribute :redeemed_at,      :datetime
        attribute :redeemed,         :boolean
        attribute :rejected,         :boolean
        attribute :message,          :string
        attribute :created_at,       :datetime
        attribute :updated_at,       :datetime

        expandable :registration, :release
      end
    end
  end
end
