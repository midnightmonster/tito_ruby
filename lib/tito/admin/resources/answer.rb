module Tito
  module Admin
    module Resources
      class Answer < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/questions/%{parent_id}/answers"
        resource_name "answer"
        collection_name "answers"
        supports :list, :show

        attribute :id,                 :integer
        attribute :question_id,        :integer
        attribute :ticket_id,          :integer
        attribute :primary_response,   :string
        attribute :alternate_response, :string
        attribute :response,           :string
        attribute :download_url,       :string

        expandable :question, :ticket
      end
    end
  end
end
