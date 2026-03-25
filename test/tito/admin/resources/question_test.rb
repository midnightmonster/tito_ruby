require "test_helper"

class Tito::Admin::Resources::QuestionTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(token: "test-token", account: "demo", event: "conf")
    @scope = Tito::Admin::Scope.new(
      client: @client, account: "demo", event: "conf",
      resource_class: Tito::Admin::Resources::Question
    )
  end

  def test_paths
    assert_equal "demo/conf/questions", @scope.collection_path
  end

  def test_answers_returns_collection_proxy
    question = Tito::Admin::Resources::Question.new(
      _scope: @scope, id: 1, slug: "q-abc", title: "Dietary needs?"
    )
    answers = question.answers
    assert_instance_of Tito::Admin::CollectionProxy, answers
  end

  def test_answers_uses_nested_path
    fetched_path = nil
    @scope.connection.define_singleton_method(:get) do |path, params: {}|
      fetched_path = path
      { "answers" => [], "meta" => { "total_count" => 0, "next_page" => nil } }
    end

    question = Tito::Admin::Resources::Question.new(
      _scope: @scope, id: 1, slug: "q-abc", title: "Dietary needs?"
    )
    question.answers.to_a

    assert_equal "demo/conf/questions/q-abc/answers", fetched_path
  end
end
