module Tito
  module Admin
    module Resources
      class Event < Tito::Resource
        account_scoped!
        path_template "events"
        member_path_template "%{account}/%{id_or_slug}"
        resource_name "event"
        collection_name "events"
        supports :list, :show, :create, :update, :delete

        attribute :id,                      :integer
        attribute :slug,                    :string
        attribute :title,                   :string
        attribute :url,                     :string
        attribute :account_id,              :integer
        attribute :account_slug,            :string
        attribute :currency,                :string
        attribute :email_address,           :string
        attribute :description,             :string

        attribute :start_date,              :string
        attribute :start_time,              :string
        attribute :end_date,                :string
        attribute :end_time,                :string
        attribute :timezone,                :string

        attribute :live,                    :boolean
        attribute :private,                 :boolean
        attribute :archived,                :boolean
        attribute :test_mode,               :boolean
        attribute :setup,                   :boolean

        attribute :tickets_count,           :integer
        attribute :registrations_count,     :integer
        attribute :releases_count,          :integer

        attribute :show_banner,             :boolean
        attribute :show_logo,               :boolean
        attribute :show_title,              :boolean
        attribute :show_prices_ex_tax,      :boolean

        attribute :require_billing_address, :boolean
        attribute :require_company_name,    :boolean
        attribute :require_vat_number,      :boolean

        attribute :max_tickets_per_person,  :integer
        attribute :min_tickets_per_person,  :integer

        attribute :security_token,          :string
        attribute :metadata,                :string

        attribute :created_at,              :datetime
        attribute :updated_at,              :datetime

        expandable :releases, :release_ids, :release_slugs, :paypal_payment_options, :currency_options

        action :duplicate, method: :post, path: "duplication"
      end
    end
  end
end
