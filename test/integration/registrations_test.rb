require "test_helper"

class RegistrationsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_registrations
    VCR.use_cassette("integration/registrations_list") do
      registrations = @client.registrations.to_a
      assert registrations.any?, "Expected at least one registration"

      reg = registrations.first
      assert_kind_of Tito::Admin::Resources::Registration, reg
      assert reg.id
      assert reg.slug
      assert reg.reference
      assert reg.email
      assert reg.name
      assert reg.state
      assert reg.registration_type
      assert_includes [true, false], reg.test_mode
      assert_kind_of Hash, reg.event
    end
  end

  def test_find_registration
    VCR.use_cassette("integration/registrations_find") do
      registrations = @client.registrations.to_a
      slug = registrations.first.slug

      reg = @client.registrations.find(slug)
      assert_kind_of Tito::Admin::Resources::Registration, reg
      assert reg.persisted?
      assert_equal slug, reg.slug
      assert reg.tickets_count
    end
  end
end
