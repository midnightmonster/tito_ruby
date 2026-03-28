require "test_helper"

class InterestedUsersIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_interested_users
    VCR.use_cassette("integration/interested_users_list") do
      users = @client.interested_users.to_a
      assert users.any?, "Expected at least one interested user"

      user = users.first
      assert_kind_of Tito::Admin::Resources::InterestedUser, user
      assert user.id
      assert user.email
      assert user.name
    end
  end

  def test_create_and_delete_interested_user
    VCR.use_cassette("integration/interested_users_crud") do
      user = @client.interested_users.create(
        email: "integration-test@example.com",
        name: "Integration Tester"
      )
      assert user.persisted?
      assert user.id
      assert_equal "integration-test@example.com", user.email

      user.destroy
      assert user.destroyed?
    end
  end
end
