module Tito
  module Admin
    module Resources
      class RsvpList < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/rsvp_lists"
        resource_name "rsvp_list"
        collection_name "rsvp_lists"
        supports :list, :show, :create, :update, :delete

        attribute :id,                         :integer
        attribute :slug,                       :string
        attribute :title,                      :string
        attribute :redeemed_count,             :integer
        attribute :nos_count,                  :integer
        attribute :maybes_count,               :integer
        attribute :release_invitations_count,  :integer
        attribute :message_slug,               :string
        attribute :created_at,                 :datetime
        attribute :updated_at,                 :datetime

        has_many :release_invitations, resource_class_name: "ReleaseInvitation"
      end
    end
  end
end
