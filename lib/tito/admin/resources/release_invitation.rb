module Tito
  module Admin
    module Resources
      class ReleaseInvitation < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/rsvp_lists/%{parent_id}/release_invitations"
        resource_name "release_invitation"
        collection_name "release_invitations"
        supports :list, :show, :create, :update, :delete

        attribute :id,             :integer
        attribute :slug,           :string
        attribute :email,          :string
        attribute :first_name,     :string
        attribute :last_name,      :string
        attribute :name,           :string
        attribute :status,         :string
        attribute :redeemed,       :boolean
        attribute :auto,           :boolean
        attribute :guest,          :boolean
        attribute :discount_code,  :string
        attribute :expires_at,     :datetime
        attribute :unique_url,     :string
        attribute :redirect,       :string
        attribute :created_at,     :datetime
        attribute :updated_at,     :datetime

        expandable :registration
      end
    end
  end
end
