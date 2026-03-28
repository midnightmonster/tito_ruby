require "test_helper"

class WebhookEndpointsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_webhook_endpoints
    VCR.use_cassette("integration/webhook_endpoints_list") do
      endpoints = @client.webhook_endpoints.to_a
      assert endpoints.any?, "Expected at least one webhook endpoint"

      endpoint = endpoints.first
      assert_kind_of Tito::Admin::Resources::WebhookEndpoint, endpoint
      assert endpoint.id
      assert endpoint.url
      assert_kind_of Array, endpoint.included_triggers
    end
  end

  def test_create_and_delete_webhook_endpoint
    VCR.use_cassette("integration/webhook_endpoints_crud") do
      endpoint = @client.webhook_endpoints.create(
        url: "https://example.com/webhooks/integration-test",
        included_triggers: ["ticket.completed"]
      )
      assert endpoint.persisted?
      assert endpoint.id
      assert_equal "https://example.com/webhooks/integration-test", endpoint.url

      endpoint.destroy
      assert endpoint.destroyed?
    end
  end
end
