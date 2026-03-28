module Tito
  module Admin
    module Resources
      class Ticket < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/tickets"
        resource_name "ticket"
        collection_name "tickets"
        supports :list, :show, :create, :update

        attribute :id,                  :integer
        attribute :slug,                :string
        attribute :reference,           :string
        attribute :number,              :integer
        attribute :email,               :string
        attribute :first_name,          :string
        attribute :last_name,           :string
        attribute :name,                :string
        attribute :company_name,        :string
        attribute :job_title,           :string
        attribute :phone_number,        :string
        attribute :state,               :string
        attribute :price,               :decimal
        attribute :price_less_tax,      :decimal
        attribute :total_paid,          :decimal
        attribute :total_paid_less_tax, :decimal
        attribute :total_tax_paid,      :decimal
        attribute :release_id,          :integer
        attribute :release_archived,    :boolean
        attribute :registration_id,     :integer
        attribute :discount_code_used,  :string
        attribute :tag_names,           :string_array
        attribute :test_mode,           :boolean
        attribute :assigned,            :boolean
        attribute :unique_url,          :string
        attribute :avatar_url,          :string
        attribute :qr_url,              :string
        attribute :qr_code_disabled,    :boolean
        attribute :show_qr_code,        :boolean
        attribute :vcard_url,           :string
        attribute :vcard_data,          :string
        attribute :changes_locked,      :boolean
        attribute :lock_changes,        :boolean
        attribute :tags,                :string
        attribute :event,               :json
        attribute :void,                :boolean
        attribute :metadata,            :json
        attribute :consented_at,        :datetime
        attribute :created_at,          :datetime
        attribute :updated_at,          :datetime

        expandable :activities, :answers, :opt_ins, :registration, :release, :responses, :upgrade_ids

        action :void!,     method: :post, path: "void"
        action :reassign!, method: :post, path: "reassignments"
      end
    end
  end
end
