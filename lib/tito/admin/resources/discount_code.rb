module Tito
  module Admin
    module Resources
      class DiscountCode < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/discount_codes"
        resource_name "discount_code"
        collection_name "discount_codes"
        supports :list, :show, :create, :update, :delete

        attribute :id,                                    :integer
        attribute :code,                                  :string
        attribute :state,                                 :string
        attribute :type,                                  :string
        attribute :value,                                 :decimal
        attribute :start_at,                              :datetime
        attribute :end_at,                                :datetime
        attribute :quantity,                              :integer
        attribute :quantity_used,                         :integer
        attribute :min_quantity_per_release,              :integer
        attribute :max_quantity_per_release,              :integer
        attribute :registrations_count,                   :integer
        attribute :tickets_count,                         :integer
        attribute :share_url,                             :string
        attribute :description,                           :string
        attribute :description_for_organizer,             :string
        attribute :show_public_releases,                  :boolean
        attribute :show_secret_releases,                  :boolean
        attribute :block_registrations_if_not_applicable, :boolean
        attribute :disable_for_degressive,                :boolean
        attribute :created_at,                            :datetime
        attribute :updated_at,                            :datetime
      end
    end
  end
end
