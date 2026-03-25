require "test_helper"

class Tito::Admin::Resources::WebhookEndpointTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(token: "test-token", account: "demo")
  end

  def test_account_scoped
    refute Tito::Admin::Resources::WebhookEndpoint.event_scoped?
  end

  def test_collection_does_not_require_event
    proxy = @client.webhook_endpoints
    assert_instance_of Tito::Admin::CollectionProxy, proxy
  end

  def test_included_triggers_as_string_array
    endpoint = Tito::Admin::Resources::WebhookEndpoint.new(
      included_triggers: %w[ticket.created registration.completed]
    )
    assert_equal %w[ticket.created registration.completed], endpoint.included_triggers
  end
end
