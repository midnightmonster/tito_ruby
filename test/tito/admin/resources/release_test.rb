require "test_helper"

class Tito::Admin::Resources::ReleaseTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(token: "test-token", account: "demo", event: "conf")
    @scope = Tito::Admin::Scope.new(
      client: @client, account: "demo", event: "conf",
      resource_class: Tito::Admin::Resources::Release
    )
  end

  def test_paths
    assert_equal "demo/conf/releases", @scope.collection_path
    assert_equal "demo/conf/releases/early-bird", @scope.member_path("early-bird")
  end

  def test_supports_full_crud
    ops = Tito::Admin::Resources::Release.supported_operations
    assert_equal %i[list show create update delete], ops
  end

  # -- Toggle actions --

  def test_archive_uses_post
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      {}
    end

    release = Tito::Admin::Resources::Release.new(_scope: @scope, id: 1, slug: "early-bird")
    release.archive!

    assert_equal "demo/conf/releases/early-bird/archival", action_path
  end

  def test_unarchive_uses_delete
    action_path = nil
    @scope.connection.define_singleton_method(:delete) do |path|
      action_path = path
      nil
    end

    release = Tito::Admin::Resources::Release.new(_scope: @scope, id: 1, slug: "early-bird")
    release.unarchive!

    assert_equal "demo/conf/releases/early-bird/archival", action_path
  end

  def test_activate_uses_patch
    action_path = nil
    @scope.connection.define_singleton_method(:patch) do |path, body: {}|
      action_path = path
      {}
    end

    release = Tito::Admin::Resources::Release.new(_scope: @scope, id: 1, slug: "early-bird")
    release.activate!

    assert_equal "demo/conf/releases/early-bird/activation", action_path
  end

  def test_deactivate_uses_patch
    action_path = nil
    @scope.connection.define_singleton_method(:patch) do |path, body: {}|
      action_path = path
      {}
    end

    release = Tito::Admin::Resources::Release.new(_scope: @scope, id: 1, slug: "early-bird")
    release.deactivate!

    assert_equal "demo/conf/releases/early-bird/deactivation", action_path
  end

  def test_publish_uses_post
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      {}
    end

    release = Tito::Admin::Resources::Release.new(_scope: @scope, id: 1, slug: "early-bird")
    release.publish!

    assert_equal "demo/conf/releases/early-bird/publication", action_path
  end

  def test_unpublish_uses_delete
    action_path = nil
    @scope.connection.define_singleton_method(:delete) do |path|
      action_path = path
      nil
    end

    release = Tito::Admin::Resources::Release.new(_scope: @scope, id: 1, slug: "early-bird")
    release.unpublish!

    assert_equal "demo/conf/releases/early-bird/publication", action_path
  end

  def test_duplicate_uses_post
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      {}
    end

    release = Tito::Admin::Resources::Release.new(_scope: @scope, id: 1, slug: "early-bird")
    release.duplicate

    assert_equal "demo/conf/releases/early-bird/duplication", action_path
  end
end
