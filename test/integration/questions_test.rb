require "test_helper"

class QuestionsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_questions
    VCR.use_cassette("integration/questions_list") do
      questions = @client.questions.to_a
      assert questions.any?, "Expected at least one question"

      q = questions.first
      assert_kind_of Tito::Admin::Resources::Question, q
      assert q.id
      assert q.slug
      assert q.title
      assert q.field_type
      assert_kind_of Array, q.options
    end
  end

  def test_find_question
    VCR.use_cassette("integration/questions_find") do
      questions = @client.questions.to_a
      slug = questions.first.slug

      q = @client.questions.find(slug)
      assert_kind_of Tito::Admin::Resources::Question, q
      assert q.persisted?
      assert_equal slug, q.slug
    end
  end

  def test_create_update_delete_question
    VCR.use_cassette("integration/questions_crud") do
      q = @client.questions.create(
        title: "Integration test question?",
        field_type: "Text",
        required: false
      )
      assert q.persisted?
      assert q.id
      assert_equal "Integration test question?", q.title

      q.title = "Updated question?"
      q.save
      assert_equal "Updated question?", q.title

      q.destroy
      assert q.destroyed?
    end
  end
end
