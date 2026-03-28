require "test_helper"

class VenuesIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_venues
    VCR.use_cassette("integration/venues_list") do
      venues = @client.venues.to_a
      # May be empty
      assert_kind_of Array, venues
    end
  end
end
