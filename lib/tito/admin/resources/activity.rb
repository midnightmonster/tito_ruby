module Tito
  module Admin
    module Resources
      class Activity < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/activities"
        resource_name "activity"
        collection_name "activities"
        supports :list, :show, :create, :update, :delete

        attribute :id,               :integer
        attribute :name,             :string
        attribute :description,      :string
        attribute :date,             :string
        attribute :start_time,       :string
        attribute :end_time,         :string
        attribute :start_at,         :datetime
        attribute :end_at,           :datetime
        attribute :capacity,         :integer
        attribute :allocation_count, :integer
        attribute :sold_out,         :boolean
        attribute :show_to_attendee, :boolean
        attribute :created_at,       :datetime
        attribute :updated_at,       :datetime

        expandable :questions, :releases, :upgrades, :venue

        action :duplicate, method: :post, path: "duplication"
      end
    end
  end
end
