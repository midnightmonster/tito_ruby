module Tito
  module Admin
    module Resources
      class Question < Tito::Resource
        event_scoped!
        path_template "%{account}/%{event}/questions"
        resource_name "question"
        collection_name "questions"
        supports :list, :show, :create, :update, :delete

        attribute :id,                      :integer
        attribute :slug,                    :string
        attribute :title,                   :string
        attribute :description,             :string
        attribute :field_type,              :string
        attribute :options,                 :json
        attribute :options_free_text_field, :string
        attribute :include_free_text_field, :boolean
        attribute :required,               :boolean
        attribute :answers_count,          :integer
        attribute :tickets_count,          :integer
        attribute :deletable,              :boolean
        attribute :public_optional_activity_ids, :json
        attribute :created_at,             :datetime
        attribute :updated_at,             :datetime

        expandable :activities, :releases

        has_many :answers, resource_class_name: "Answer"
      end
    end
  end
end
