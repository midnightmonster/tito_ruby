require "test_helper"

class CheckinListsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  # NOTE: The checkin_lists list endpoint returns 500 when page[number] param
  # is sent. Skipping list test until Tito fixes this API bug.

  def test_create_and_delete_checkin_list
    VCR.use_cassette("integration/checkin_lists_crud") do
      list = @client.checkin_lists.create(title: "Integration Test Checkin")
      assert list.persisted?
      assert list.id
      assert_equal "Integration Test Checkin", list.title

      list.destroy
      assert list.destroyed?
    end
  end
end
