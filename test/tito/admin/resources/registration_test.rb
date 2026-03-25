require "test_helper"

class Tito::Admin::Resources::RegistrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(token: "test-token", account: "demo", event: "conf")
    @scope = Tito::Admin::Scope.new(
      client: @client, account: "demo", event: "conf",
      resource_class: Tito::Admin::Resources::Registration
    )
  end

  def test_event_scoped
    assert Tito::Admin::Resources::Registration.event_scoped?
  end

  def test_paths
    assert_equal "demo/conf/registrations", @scope.collection_path
    assert_equal "demo/conf/registrations/reg-abc", @scope.member_path("reg-abc")
  end

  # -- Attributes --

  def test_attributes
    reg = Tito::Admin::Resources::Registration.new(
      id: 1, slug: "reg-abc", email: "buyer@example.com", name: "Test Buyer",
      total: "50.00", paid: true
    )

    assert_equal "buyer@example.com", reg.email
    assert_equal 50.0, reg.total
    assert_equal true, reg.paid
  end

  # -- Special actions --

  def test_confirm_action
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      { "registration" => { "id" => 1, "slug" => "reg-abc", "paid" => true } }
    end

    reg = Tito::Admin::Resources::Registration.new(_scope: @scope, id: 1, slug: "reg-abc", paid: false)
    reg.confirm!

    assert_equal "demo/conf/registrations/reg-abc/confirmations", action_path
    assert_equal true, reg.paid
  end

  def test_unconfirm_action
    action_path = nil
    action_method = nil
    @scope.connection.define_singleton_method(:delete) do |path|
      action_path = path
      action_method = :delete
      nil
    end

    reg = Tito::Admin::Resources::Registration.new(_scope: @scope, id: 1, slug: "reg-abc")
    reg.unconfirm!

    assert_equal "demo/conf/registrations/reg-abc/confirmations", action_path
    assert_equal :delete, action_method
  end

  def test_cancel_action
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      { "registration" => { "id" => 1, "slug" => "reg-abc", "cancelled" => true } }
    end

    reg = Tito::Admin::Resources::Registration.new(_scope: @scope, id: 1, slug: "reg-abc")
    reg.cancel!

    assert_equal "demo/conf/registrations/reg-abc/cancellation", action_path
    assert_equal true, reg.cancelled
  end

  def test_refund_action
    action_path = nil
    @scope.connection.define_singleton_method(:post) do |path, body: {}|
      action_path = path
      {}
    end

    reg = Tito::Admin::Resources::Registration.new(_scope: @scope, id: 1, slug: "reg-abc")
    reg.refund!

    assert_equal "demo/conf/registrations/reg-abc/refunds", action_path
  end

  # -- Nested refunds --

  def test_refunds_returns_collection_proxy
    reg = Tito::Admin::Resources::Registration.new(_scope: @scope, id: 1, slug: "reg-abc")
    refunds = reg.refunds
    assert_instance_of Tito::Admin::CollectionProxy, refunds
  end

  def test_refunds_collection_proxy_uses_nested_path
    fetched_path = nil
    @scope.connection.define_singleton_method(:get) do |path, params: {}|
      fetched_path = path
      { "refunds" => [], "meta" => { "total_count" => 0, "next_page" => nil } }
    end

    reg = Tito::Admin::Resources::Registration.new(_scope: @scope, id: 1, slug: "reg-abc")
    reg.refunds.to_a

    assert_equal "demo/conf/registrations/reg-abc/refunds", fetched_path
  end
end
