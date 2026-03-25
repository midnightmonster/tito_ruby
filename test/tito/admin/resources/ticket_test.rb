require "test_helper"

class Tito::Admin::Resources::TicketTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(token: "test-token", account: "demo", event: "conf")
    @scope = Tito::Admin::Scope.new(
      client: @client, account: "demo", event: "conf",
      resource_class: Tito::Admin::Resources::Ticket
    )
  end

  # -- DSL --

  def test_event_scoped
    assert Tito::Admin::Resources::Ticket.event_scoped?
  end

  def test_path_template
    assert_equal "%{account}/%{event}/tickets", Tito::Admin::Resources::Ticket.path_template
  end

  def test_collection_path
    assert_equal "demo/conf/tickets", @scope.collection_path
  end

  def test_member_path
    assert_equal "demo/conf/tickets/ti_abc", @scope.member_path("ti_abc")
  end

  def test_supports_no_delete
    ops = Tito::Admin::Resources::Ticket.supported_operations
    assert_includes ops, :list
    assert_includes ops, :show
    assert_includes ops, :create
    assert_includes ops, :update
    refute_includes ops, :delete
  end

  # -- Attributes --

  def test_attributes_from_api_response
    ticket = Tito::Admin::Resources::Ticket.new(
      _scope: @scope,
      id: 1, slug: "ti_abc", first_name: "Ada", last_name: "Lovelace",
      email: "ada@example.com", state: "complete", price: "25.00",
      test_mode: false
    )

    assert_equal 1, ticket.id
    assert_equal "ti_abc", ticket.slug
    assert_equal "Ada", ticket.first_name
    assert_equal "Lovelace", ticket.last_name
    assert_equal "ada@example.com", ticket.email
    assert_equal "complete", ticket.state
    assert_equal 25.0, ticket.price
    assert_equal false, ticket.test_mode
  end

  def test_tag_names_as_string_array
    ticket = Tito::Admin::Resources::Ticket.new(tag_names: %w[vip speaker])
    assert_equal %w[vip speaker], ticket.tag_names
  end

  # -- Save (create) --

  def test_save_new_record_posts
    posted_path = nil
    posted_body = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      posted_path = path
      posted_body = body
      { "ticket" => { "id" => 99, "slug" => "ti_new", "first_name" => "Grace", "state" => "incomplete" } }
    end

    ticket = Tito::Admin::Resources::Ticket.new(_scope: @scope, first_name: "Grace", email: "grace@example.com")
    ticket.save

    assert_equal "demo/conf/tickets", posted_path
    assert_equal "Grace", posted_body.dig("ticket", "first_name")
    assert_equal 99, ticket.id
    assert_equal "ti_new", ticket.slug
    assert ticket.persisted?
    refute ticket.changed?
  end

  # -- Save (update) --

  def test_save_persisted_record_patches_only_changed
    patched_path = nil
    patched_body = nil
    @scope.connection.define_singleton_method(:patch) do |path, body: {}|
      patched_path = path
      patched_body = body
      { "ticket" => { "id" => 1, "slug" => "ti_abc", "first_name" => "Grace", "last_name" => "Hopper" } }
    end

    ticket = Tito::Admin::Resources::Ticket.new(
      _scope: @scope, id: 1, slug: "ti_abc", first_name: "Ada", last_name: "Lovelace"
    )
    ticket.first_name = "Grace"
    ticket.save

    assert_equal "demo/conf/tickets/ti_abc", patched_path
    assert_equal({ "ticket" => { "first_name" => "Grace" } }, patched_body)
    assert_equal "Grace", ticket.first_name
    refute ticket.changed?
  end

  # -- Find via collection proxy --

  def test_find_returns_persisted_ticket
    @scope.connection.define_singleton_method(:get) do |path, params: {}|
      { "ticket" => { "id" => 5, "slug" => "ti_xyz", "first_name" => "Alan", "state" => "complete" } }
    end

    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    ticket = proxy.find("ti_xyz")
    assert_equal "Alan", ticket.first_name
    assert ticket.persisted?
  end

  # -- Special actions --

  def test_void_action
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      { "ticket" => { "id" => 1, "slug" => "ti_abc", "state" => "void" } }
    end

    ticket = Tito::Admin::Resources::Ticket.new(_scope: @scope, id: 1, slug: "ti_abc", state: "complete")
    result = ticket.void!

    assert_equal "demo/conf/tickets/ti_abc/void", action_path
    assert_equal "void", ticket.state
    assert_same ticket, result
  end

  def test_reassign_action
    action_path = nil
    action_body = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      action_body = body
      {}
    end

    ticket = Tito::Admin::Resources::Ticket.new(_scope: @scope, id: 1, slug: "ti_abc")
    ticket.reassign!(email: "new@example.com", first_name: "New")

    assert_equal "demo/conf/tickets/ti_abc/reassignments", action_path
    assert_equal "new@example.com", action_body.dig("ticket", :email)
  end

  # -- Dirty tracking --

  def test_dirty_tracking_on_persisted_ticket
    ticket = Tito::Admin::Resources::Ticket.new(_scope: @scope, id: 1, slug: "ti_abc", first_name: "Ada")
    refute ticket.changed?

    ticket.first_name = "Grace"
    assert ticket.changed?
    assert_equal ["first_name"], ticket.changed
  end
end
