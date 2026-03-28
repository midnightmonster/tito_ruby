require "test_helper"

class ActivitiesIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_activities
    VCR.use_cassette("integration/activities_list") do
      activities = @client.activities.to_a
      assert activities.any?, "Expected at least one activity"

      activity = activities.first
      assert_kind_of Tito::Admin::Resources::Activity, activity
      assert activity.id
      assert activity.name
      assert activity.kind
    end
  end

  def test_create_and_delete_activity
    VCR.use_cassette("integration/activities_crud") do
      activity = @client.activities.create(
        name: "Integration Test Activity",
        description: "Created by integration test"
      )
      assert activity.persisted?
      assert activity.id
      assert_equal "Integration Test Activity", activity.name

      activity.destroy
      assert activity.destroyed?
    end
  end
end
