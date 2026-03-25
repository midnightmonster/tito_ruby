module Tito
  module Admin
    module Resources
      class CheckinList < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/checkin_lists"
        resource_name "checkin_list"
        collection_name "checkin_lists"
        supports :list, :show, :create, :update, :delete

        attribute :id,                  :integer
        attribute :slug,                :string
        attribute :title,               :string
        attribute :web_checkin_url,     :string
        attribute :qr_code_url,        :string
        attribute :expires_at,          :datetime
        attribute :expired,             :boolean
        attribute :open,                :boolean
        attribute :state,               :string
        attribute :show_email,          :boolean
        attribute :show_company_name,   :boolean
        attribute :show_phone_number,   :boolean
        attribute :hide_unpaid,         :boolean
        attribute :checked_in_count,    :integer
        attribute :checked_in_percent,  :decimal
        attribute :tickets_count,       :integer
        attribute :created_at,          :datetime
        attribute :updated_at,          :datetime

        expandable :activities, :questions, :releases
      end
    end
  end
end
