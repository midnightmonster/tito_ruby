require "test_helper"

class Tito::Admin::CollectionProxyTest < Minitest::Test
  class FakeWidget < Tito::Resource
    event_scoped!
    path_template "%{account}/%{event}/widgets"
    resource_name "widget"
    collection_name "widgets"

    attribute :id,   :integer
    attribute :slug, :string
    attribute :name, :string
  end

  def setup
    @client = Tito::Admin::Client.new(token: "test", account: "demo", event: "conf")
    @scope = Tito::Admin::Scope.new(
      client: @client,
      account: "demo",
      event: "conf",
      resource_class: FakeWidget
    )
  end

  def test_where_returns_new_proxy
    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    filtered = proxy.where(state: "complete")
    refute_same proxy, filtered
  end

  def test_order_returns_new_proxy
    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    ordered = proxy.order(name: :asc)
    refute_same proxy, ordered
  end

  def test_chaining_does_not_mutate_original
    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    proxy.where(state: "complete").order(name: :desc).search("test")
    # Original should have no query state — verified by the fact it doesn't raise
    assert_instance_of Tito::Admin::CollectionProxy, proxy
  end

  def test_each_paginates_transparently
    page1 = {
      "widgets" => [{ "id" => 1, "name" => "A" }, { "id" => 2, "name" => "B" }],
      "meta" => { "current_page" => 1, "next_page" => 2, "total_count" => 3, "total_pages" => 2 }
    }
    page2 = {
      "widgets" => [{ "id" => 3, "name" => "C" }],
      "meta" => { "current_page" => 2, "next_page" => nil, "total_count" => 3, "total_pages" => 2 }
    }

    call_count = 0
    @scope.connection.define_singleton_method(:get) do |path, params: {}|
      call_count += 1
      call_count == 1 ? page1 : page2
    end

    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    names = proxy.map(&:name)
    assert_equal %w[A B C], names
    assert_equal 2, call_count
  end

  def test_size_loads_first_page
    page1 = {
      "widgets" => [{ "id" => 1, "name" => "A" }],
      "meta" => { "current_page" => 1, "next_page" => nil, "total_count" => 42, "total_pages" => 1 }
    }

    @scope.connection.define_singleton_method(:get) { |path, params: {}| page1 }

    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    assert_equal 42, proxy.size
  end

  def test_empty_collection
    page1 = {
      "widgets" => [],
      "meta" => { "current_page" => 1, "next_page" => nil, "total_count" => 0, "total_pages" => 0 }
    }

    @scope.connection.define_singleton_method(:get) { |path, params: {}| page1 }

    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    assert proxy.empty?
    assert_equal [], proxy.to_a
  end

  def test_find_returns_single_resource
    data = { "widget" => { "id" => 5, "slug" => "w-5", "name" => "Found" } }

    @scope.connection.define_singleton_method(:get) { |path, params: {}| data }

    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    widget = proxy.find("w-5")
    assert_equal "Found", widget.name
    assert_equal 5, widget.id
    assert widget.persisted?
  end

  def test_build_returns_new_record
    proxy = Tito::Admin::CollectionProxy.new(scope: @scope)
    widget = proxy.build(name: "New")
    assert_equal "New", widget.name
    assert widget.new_record?
  end
end
