module Tito
  module Admin
    module Resources
      class Release < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/releases"
        resource_name "release"
        collection_name "releases"
        supports :list, :show, :create, :update, :delete

        # Identity
        attribute :id,                              :integer
        attribute :slug,                            :string
        attribute :title,                           :string
        attribute :description,                     :string
        attribute :event_id,                        :integer

        # Pricing
        attribute :price,                           :decimal
        attribute :price_ex_tax,                    :decimal
        attribute :display_price,                   :decimal
        attribute :payment_type,                    :string
        attribute :pricing_type,                    :string
        attribute :donation,                        :boolean
        attribute :suggested_donation,              :decimal
        attribute :max_donation,                    :decimal
        attribute :min_donation,                    :decimal
        attribute :price_degressive,                :json
        attribute :price_degressive_list,           :json
        attribute :tax_exclusive,                   :boolean
        attribute :tax_description,                 :string

        # Quantity
        attribute :quantity,                        :integer
        attribute :default_quantity,                :integer
        attribute :tickets_count,                   :integer
        attribute :allocatable,                     :boolean
        attribute :position,                        :integer

        # Ticket counts
        attribute :full_price_tickets_count,        :integer
        attribute :free_tickets_count,              :integer
        attribute :discounted_tickets_count,        :integer
        attribute :voided_tickets_count,            :integer

        # Financial
        attribute :gross_income,                    :decimal

        # State
        attribute :sold_out,                        :boolean
        attribute :archived,                        :boolean
        attribute :off_sale,                        :boolean
        attribute :locked,                          :boolean
        attribute :expired,                         :boolean
        attribute :upcoming,                        :boolean
        attribute :secret,                          :boolean
        attribute :deletable,                       :boolean
        attribute :changes_locked,                  :boolean
        attribute :state_name,                      :string

        # Options
        attribute :not_a_ticket,                    :boolean
        attribute :lock_changes,                    :boolean
        attribute :only_issue_combos,               :boolean
        attribute :card_payments,                   :boolean
        attribute :invoice,                         :boolean
        attribute :enable_super_combo_summary,      :boolean
        attribute :has_success_message,             :boolean
        attribute :has_fail_message,                :boolean

        # Requirements
        attribute :require_email,                   :boolean
        attribute :require_name,                    :boolean
        attribute :require_billing_address,         :boolean
        attribute :require_company_name,            :boolean
        attribute :require_vat_number,              :boolean
        attribute :require_job_title,               :boolean
        attribute :require_credit_card_for_sold_out_waiting_list, :boolean

        # Request fields
        attribute :request_company_name,            :boolean
        attribute :request_job_title,               :boolean
        attribute :request_vat_number,              :boolean

        # Display
        attribute :show_price,                      :boolean
        attribute :show_qr_code,                    :boolean
        attribute :show_discount_code_field_here,   :boolean
        attribute :show_company_name,               :boolean
        attribute :show_job_title,                  :boolean
        attribute :show_phone_number,               :boolean
        attribute :show_vat_number,                 :boolean
        attribute :share_url,                       :string

        # Per-person limits
        attribute :max_tickets_per_person,          :integer
        attribute :min_tickets_per_person,          :integer

        # Dates
        attribute :start_at,                        :datetime
        attribute :end_at,                          :datetime

        # Waiting list
        attribute :waiting_list,                    :boolean
        attribute :pending_waiting_list,            :boolean
        attribute :waiting_list_enabled_during_locked, :boolean
        attribute :waiting_list_enabled_during_sold_out, :boolean

        # Other
        attribute :metadata,                        :json
        attribute :warnings,                        :json
        attribute :created_at,                      :datetime
        attribute :updated_at,                      :datetime

        expandable :activities, :activity_questions, :combo_releases, :questions, :super_combo_releases, :tax_components, :tax_types, :termset, :ticket_group

        action :archive!,    method: :post,   path: "archival"
        action :unarchive!,  method: :delete, path: "archival"
        action :activate!,   method: :patch,  path: "activation"
        action :deactivate!, method: :patch,  path: "deactivation"
        action :publish!,    method: :post,   path: "publication"
        action :unpublish!,  method: :delete, path: "publication"
        action :duplicate,   method: :post,   path: "duplication"
      end
    end
  end
end
