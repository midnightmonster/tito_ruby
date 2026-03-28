module Tito
  module Admin
    module Resources
      class Registration < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/registrations"
        resource_name "registration"
        collection_name "registrations"
        supports :list, :show, :create, :update

        attribute :id,                          :integer
        attribute :slug,                        :string
        attribute :reference,                   :string
        attribute :email,                       :string
        attribute :name,                        :string
        attribute :phone_number,                :string
        attribute :job_title,                   :string
        attribute :company_name,                :string

        # Payment
        attribute :payment_reference,           :string
        attribute :payment_option_name,         :string
        attribute :payment_option_provider_name, :string
        attribute :purchase_order_number,       :string
        attribute :total,                       :decimal
        attribute :total_less_tax,              :decimal
        attribute :paid,                        :boolean
        attribute :free,                        :boolean
        attribute :invoice,                     :boolean
        attribute :payment_complete,            :boolean
        attribute :payment_incomplete,          :boolean

        # Receipt
        attribute :receipt_id,                  :integer
        attribute :receipt_number,              :string
        attribute :receipt_paid,                :boolean

        # State
        attribute :state,                       :string
        attribute :registration_type,           :string
        attribute :cancelled,                   :boolean
        attribute :cancelled_at,                :datetime
        attribute :cancelled_by,                :string
        attribute :refundable,                  :boolean
        attribute :refunded,                    :boolean
        attribute :partially_refunded,          :boolean
        attribute :editable_total_and_prices,   :boolean
        attribute :completed_at,                :datetime
        attribute :consented_at,                :datetime
        attribute :expires_at,                  :string

        # Metadata
        attribute :locale,                      :string
        attribute :source,                      :string
        attribute :ip_address,                  :string
        attribute :metadata,                    :json
        attribute :event,                       :json
        attribute :quantities,                  :json

        # Relations
        attribute :discount_code,               :string
        attribute :discount_code_id,            :integer
        attribute :tickets_count,               :integer
        attribute :terms_accepted,              :boolean
        attribute :termset_ids,                 :json

        # Flags
        attribute :imported,                    :boolean
        attribute :manual,                      :boolean
        attribute :test_mode,                   :boolean

        attribute :created_at,                  :datetime
        attribute :updated_at,                  :datetime

        expandable :billing_address, :receipts, :refunds, :tickets, :line_items

        action :confirm!,   method: :post,   path: "confirmations"
        action :unconfirm!, method: :delete, path: "confirmations"
        action :refund!,    method: :post,   path: "refunds"
        action :cancel!,    method: :post,   path: "cancellation"

        has_many :refunds, resource_class_name: "Refund"
      end
    end
  end
end
