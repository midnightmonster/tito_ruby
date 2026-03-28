require "test_helper"

class RsvpListsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_rsvp_lists
    VCR.use_cassette("integration/rsvp_lists_list") do
      lists = @client.rsvp_lists.to_a
      assert lists.any?, "Expected at least one RSVP list"

      list = lists.first
      assert_kind_of Tito::Admin::Resources::RsvpList, list
      assert list.id
      assert list.slug
      assert list.title
      assert_kind_of Integer, list.release_invitations_count
    end
  end

  def test_create_and_delete_rsvp_list
    VCR.use_cassette("integration/rsvp_lists_crud") do
      list = @client.rsvp_lists.create(title: "Integration Test RSVP")
      assert list.persisted?
      assert list.id
      assert_equal "Integration Test RSVP", list.title

      list.destroy
      assert list.destroyed?
    end
  end

  def test_nested_release_invitations
    VCR.use_cassette("integration/rsvp_lists_release_invitations") do
      lists = @client.rsvp_lists.to_a
      list = lists.first

      invitations = list.release_invitations.to_a
      assert invitations.any?, "Expected at least one release invitation"

      inv = invitations.first
      assert_kind_of Tito::Admin::Resources::ReleaseInvitation, inv
      assert inv.id
      assert inv.slug
      assert inv.email
    end
  end
end
