module Tito
  module Admin
    module Resources
      class Release < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/releases"
        resource_name "release"
        collection_name "releases"
        supports :list, :show, :create, :update, :delete

        attribute :id,                              :integer
        attribute :slug,                            :string
        attribute :title,                           :string
        attribute :description,                     :string
        attribute :event_id,                        :integer
        attribute :price,                           :decimal
        attribute :price_ex_tax,                    :decimal
        attribute :display_price,                   :string
        attribute :payment_type,                    :string
        attribute :quantity,                        :integer
        attribute :tickets_count,                   :integer
        attribute :allocatable,                     :integer
        attribute :sold_out,                        :boolean
        attribute :archived,                        :boolean
        attribute :off_sale,                        :boolean
        attribute :locked,                          :boolean
        attribute :expired,                         :boolean
        attribute :upcoming,                        :boolean
        attribute :secret,                          :boolean
        attribute :not_a_ticket,                    :boolean
        attribute :lock_changes,                    :boolean
        attribute :only_issue_combos,               :boolean
        attribute :card_payments,                   :boolean
        attribute :invoice,                         :boolean
        attribute :donation,                        :boolean
        attribute :require_email,                   :boolean
        attribute :require_name,                    :boolean
        attribute :require_billing_address,         :boolean
        attribute :require_company_name,            :boolean
        attribute :require_vat_number,              :boolean
        attribute :show_price,                      :boolean
        attribute :show_qr_code,                    :boolean
        attribute :show_discount_code_field_here,   :boolean
        attribute :max_tickets_per_person,          :integer
        attribute :min_tickets_per_person,          :integer
        attribute :start_at,                        :datetime
        attribute :end_at,                          :datetime
        attribute :success_message,                 :string
        attribute :fail_message,                    :string
        attribute :metadata,                        :string
        attribute :tax_exclusive,                   :boolean
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
