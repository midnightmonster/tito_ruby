module Tito
  module Admin
    module Resources
      class Registration < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/registrations"
        resource_name "registration"
        collection_name "registrations"
        supports :list, :show, :create, :update

        attribute :id,                  :integer
        attribute :slug,                :string
        attribute :reference,           :string
        attribute :email,               :string
        attribute :name,                :string
        attribute :phone_number,        :string
        attribute :job_title,           :string
        attribute :company_name,        :string
        attribute :payment_reference,   :string
        attribute :total,               :decimal
        attribute :total_less_tax,      :decimal
        attribute :paid,                :boolean
        attribute :payment_complete,    :boolean
        attribute :payment_incomplete,  :boolean
        attribute :cancelled,           :boolean
        attribute :cancelled_at,        :datetime
        attribute :completed_at,        :datetime
        attribute :consented_at,        :datetime
        attribute :locale,              :string
        attribute :metadata,            :string
        attribute :discount_code_id,    :integer
        attribute :imported,            :boolean
        attribute :manual,              :boolean
        attribute :test_mode,           :boolean
        attribute :created_at,          :datetime
        attribute :updated_at,          :datetime

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
