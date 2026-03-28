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

        # Identity
        attribute :id,                      :integer
        attribute :slug,                    :string
        attribute :title,                   :string
        attribute :display_title,           :string
        attribute :description,             :string
        attribute :url,                     :string
        attribute :currency,                :string
        attribute :location,                :string

        # Account
        attribute :account_id,              :integer
        attribute :account_slug,            :string
        attribute :email_address,           :string
        attribute :from_email,              :string
        attribute :reply_to_email,          :string

        # Display
        attribute :banner,                  :json
        attribute :banner_url,              :string
        attribute :banner_alt_text,         :string
        attribute :logo,                    :json
        attribute :display_date,            :string
        attribute :homepage_url,            :string
        attribute :theme,                   :string

        # Dates
        attribute :start_date,              :string
        attribute :start_time,              :string
        attribute :end_date,                :string
        attribute :end_time,                :string
        attribute :start_at,                :datetime
        attribute :end_at,                  :datetime
        attribute :timezone,                :string
        attribute :date_or_range,           :string
        attribute :happening_in,            :string
        attribute :day_number,              :integer
        attribute :days_until,              :integer
        attribute :days_since,              :integer

        # Status
        attribute :live,                    :boolean
        attribute :private,                 :boolean
        attribute :archived,                :boolean
        attribute :test_mode,               :boolean
        attribute :setup,                   :boolean
        attribute :any_live_sales,          :boolean
        attribute :any_live_tickets,        :boolean
        attribute :anonymisation_state,     :string
        attribute :deletion_state,          :string

        # Counts
        attribute :tickets_count,           :integer
        attribute :registrations_count,     :integer
        attribute :releases_count,          :integer
        attribute :discount_codes_count,    :integer
        attribute :users_count,             :integer

        # Financial
        attribute :gross_income,            :decimal
        attribute :net_income,              :decimal

        # Locale
        attribute :default_locale,          :string
        attribute :locales,                 :string_array
        attribute :allow_browser_locale,    :boolean

        # Display toggles
        attribute :show_banner,             :boolean
        attribute :show_logo,               :boolean
        attribute :show_title,              :boolean
        attribute :show_description,        :boolean
        attribute :show_date,               :boolean
        attribute :show_location,           :boolean
        attribute :show_venue,              :boolean
        attribute :show_prices_ex_tax,      :boolean
        attribute :show_discount_code_field, :boolean
        attribute :show_sharing_links,      :boolean
        attribute :show_tickets_remaining,  :boolean
        attribute :show_tickets_remaining_threshold, :integer
        attribute :show_company_field,      :boolean
        attribute :show_job_title_field,    :boolean
        attribute :show_phone_number_field, :boolean
        attribute :show_email_address,      :boolean
        attribute :show_additional_info,    :boolean
        attribute :show_register_interest_form, :boolean
        attribute :show_past_tickets,       :boolean
        attribute :show_next_tickets,       :boolean
        attribute :show_order_summary,      :boolean

        # Requirements
        attribute :requires_billing_address, :boolean
        attribute :requires_company_name,   :boolean
        attribute :requires_vat_number,     :boolean
        attribute :requires_job_title,      :boolean
        attribute :requires_country,        :boolean

        # Tickets per person/registration
        attribute :max_tickets_per_person,  :integer
        attribute :min_tickets_per_person,  :integer
        attribute :max_tickets_per_registration, :integer
        attribute :min_tickets_per_registration, :integer

        # Ticket configuration
        attribute :ticket_qr_codes_enabled,    :boolean
        attribute :ticket_downloads_enabled,   :boolean
        attribute :ticket_wallet_pass_enabled, :boolean
        attribute :ticket_vcards_enabled,      :boolean
        attribute :ticket_gifting_disabled,     :boolean
        attribute :ticket_cancelling_enabled,  :boolean
        attribute :ticket_unique_emails,       :boolean
        attribute :ticket_success_message,     :string
        attribute :ticket_fail_message,        :string

        # Email settings
        attribute :send_registration_confirmation_email, :boolean
        attribute :send_ticket_gifted_email,   :boolean
        attribute :send_ticket_updated_email,  :boolean

        # Payment
        attribute :payment_option_required, :boolean

        # Admin
        attribute :security_token,          :string
        attribute :admin_control_token,     :string
        attribute :consent,                 :json
        attribute :chosen_homepage,         :string
        attribute :metadata,                :json

        attribute :created_at,              :datetime
        attribute :updated_at,              :datetime

        expandable :releases, :release_ids, :release_slugs, :paypal_payment_options, :currency_options

        action :duplicate, method: :post, path: "duplication"
      end
    end
  end
end
