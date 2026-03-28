require "test_helper"

class EventsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_events
    VCR.use_cassette("integration/events_list") do
      events = @client.events.to_a
      assert events.any?, "Expected at least one event"

      event = events.first
      assert_kind_of Tito::Admin::Resources::Event, event
      assert event.id
      assert event.slug
      assert event.title
      assert event.currency
      assert_includes [true, false], event.live
      assert_includes [true, false], event.test_mode
    end
  end

  def test_find_event
    VCR.use_cassette("integration/events_find") do
      event = @client.events.find(TITO_TEST_EVENT)
      assert_kind_of Tito::Admin::Resources::Event, event
      assert event.persisted?
      assert event.id
      assert event.slug
      assert event.title
      assert event.account_id
      assert event.account_slug
      assert event.security_token
    end
  end
end
