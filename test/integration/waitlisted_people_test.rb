require "test_helper"

class WaitlistedPeopleIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_waitlisted_people
    VCR.use_cassette("integration/waitlisted_people_list") do
      people = @client.waitlisted_people.to_a
      # May be empty if no releases have waiting lists enabled
      assert_kind_of Array, people
    end
  end
end
