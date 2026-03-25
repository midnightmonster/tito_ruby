require "test_helper"

class Tito::Admin::Resources::EventTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(token: "test-token", account: "demo", event: "conf")
    @scope = Tito::Admin::Scope.new(
      client: @client, account: "demo",
      resource_class: Tito::Admin::Resources::Event
    )
  end

  # -- DSL --

  def test_account_scoped
    refute Tito::Admin::Resources::Event.event_scoped?
  end

  def test_collection_path
    assert_equal "events", @scope.collection_path
  end

  def test_member_path_uses_custom_template
    assert_equal "demo/conf", @scope.member_path("conf")
  end

  def test_does_not_require_event
    scope = Tito::Admin::Scope.new(
      client: @client, account: "demo",
      resource_class: Tito::Admin::Resources::Event
    )
    assert_equal "events", scope.collection_path
  end

  # -- Attributes --

  def test_attributes
    event = Tito::Admin::Resources::Event.new(
      id: 1, slug: "conf-2026", title: "Conference 2026",
      live: true, test_mode: false, tickets_count: 250
    )

    assert_equal 1, event.id
    assert_equal "conf-2026", event.slug
    assert_equal "Conference 2026", event.title
    assert_equal true, event.live
    assert_equal 250, event.tickets_count
  end

  # -- Save (create) --

  def test_create_event
    posted_path = nil
    posted_body = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      posted_path = path
      posted_body = body
      { "event" => { "id" => 10, "slug" => "new-event", "title" => "New Event" } }
    end

    event = Tito::Admin::Resources::Event.new(
      _scope: @scope, title: "New Event", email_address: "info@example.com"
    )
    event.save

    assert_equal "events", posted_path
    assert_equal "New Event", posted_body.dig("event", "title")
    assert_equal 10, event.id
    assert_equal "new-event", event.slug
    assert event.persisted?
  end

  # -- Save (update) --

  def test_update_event_uses_member_path
    patched_path = nil
    @scope.connection.define_singleton_method(:patch) do |path, body: {}|
      patched_path = path
      { "event" => { "id" => 1, "slug" => "conf-2026", "title" => "Updated" } }
    end

    event = Tito::Admin::Resources::Event.new(
      _scope: @scope, id: 1, slug: "conf-2026", title: "Conference 2026"
    )
    event.title = "Updated"
    event.save

    assert_equal "demo/conf-2026", patched_path
  end

  # -- past_events / archived_events on client --

  def test_past_events_uses_path_suffix
    fetched_path = nil
    @client.connection.define_singleton_method(:get) do |path, params: {}|
      fetched_path = path
      { "events" => [], "meta" => { "total_count" => 0, "next_page" => nil } }
    end

    @client.past_events.to_a
    assert_equal "events/past", fetched_path
  end

  def test_archived_events_uses_path_suffix
    fetched_path = nil
    @client.connection.define_singleton_method(:get) do |path, params: {}|
      fetched_path = path
      { "events" => [], "meta" => { "total_count" => 0, "next_page" => nil } }
    end

    @client.archived_events.to_a
    assert_equal "events/archived", fetched_path
  end

  # -- Duplicate action --

  def test_duplicate_action
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      {}
    end

    event = Tito::Admin::Resources::Event.new(_scope: @scope, id: 1, slug: "conf-2026")
    event.duplicate

    assert_equal "demo/conf-2026/duplication", action_path
  end

  # -- Destroy --

  def test_destroy
    deleted_path = nil
    @scope.connection.define_singleton_method(:delete) do |path|
      deleted_path = path
      nil
    end

    event = Tito::Admin::Resources::Event.new(_scope: @scope, id: 1, slug: "conf-2026")
    event.destroy

    assert_equal "demo/conf-2026", deleted_path
    assert event.destroyed?
  end
end
