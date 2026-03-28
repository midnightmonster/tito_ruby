require "test_helper"

class TicketsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_tickets
    VCR.use_cassette("integration/tickets_list") do
      tickets = @client.tickets.to_a
      assert tickets.any?, "Expected at least one ticket"

      ticket = tickets.first
      assert_kind_of Tito::Admin::Resources::Ticket, ticket
      assert ticket.id
      assert ticket.slug
      assert ticket.reference
      assert ticket.email
      assert ticket.name
      assert ticket.state
      assert_kind_of Hash, ticket.event
      assert_includes [true, false], ticket.void
    end
  end

  def test_find_ticket
    VCR.use_cassette("integration/tickets_find") do
      # First get a ticket slug from the list
      tickets = @client.tickets.to_a
      slug = tickets.first.slug

      ticket = @client.tickets.find(slug)
      assert_kind_of Tito::Admin::Resources::Ticket, ticket
      assert ticket.persisted?
      assert_equal slug, ticket.slug
      assert ticket.registration_id
      assert ticket.release_id
    end
  end
end
