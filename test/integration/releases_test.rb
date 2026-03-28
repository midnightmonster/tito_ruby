require "test_helper"

class ReleasesIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_releases
    VCR.use_cassette("integration/releases_list") do
      releases = @client.releases.to_a
      assert releases.any?, "Expected at least one release"

      release = releases.first
      assert_kind_of Tito::Admin::Resources::Release, release
      assert release.id
      assert release.slug
      assert release.title
      assert release.payment_type
      assert release.pricing_type
      assert release.state_name
      assert_includes [true, false], release.sold_out
    end
  end

  def test_find_release
    VCR.use_cassette("integration/releases_find") do
      release = @client.releases.find("basic")
      assert_kind_of Tito::Admin::Resources::Release, release
      assert release.persisted?
      assert_equal "basic", release.slug
      assert release.title
      assert release.event_id
    end
  end

  def test_create_and_delete_release
    VCR.use_cassette("integration/releases_create_delete") do
      release = @client.releases.create(title: "Integration Test Release")
      assert release.persisted?
      assert release.id
      assert release.slug
      assert_equal "Integration Test Release", release.title

      release.destroy
      assert release.destroyed?
    end
  end
end
