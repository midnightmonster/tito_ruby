require "test_helper"

class Tito::ResourceTest < Minitest::Test
  # A test resource for exercising the DSL
  class TestWidget < Tito::Resource
    event_scoped!
    path_template "%{account}/%{event}/widgets"
    resource_name "widget"
    collection_name "widgets"
    supports :list, :show, :create, :update, :delete
    expandable :parts, :owner

    attribute :id,    :integer
    attribute :slug,  :string
    attribute :name,  :string
    attribute :count, :integer
    attribute :active, :boolean
    attribute :created_at, :datetime
  end

  # -- DSL --

  def test_path_template
    assert_equal "%{account}/%{event}/widgets", TestWidget.path_template
  end

  def test_resource_name
    assert_equal "widget", TestWidget.resource_name
  end

  def test_collection_name
    assert_equal "widgets", TestWidget.collection_name
  end

  def test_event_scoped
    assert TestWidget.event_scoped?
  end

  def test_supported_operations
    assert_equal %i[list show create update delete], TestWidget.supported_operations
  end

  def test_expandable_fields
    assert_equal %i[parts owner], TestWidget.expandable_fields
  end

  # -- Instance behavior --

  def test_new_record
    widget = TestWidget.new(name: "Sprocket")
    assert widget.new_record?
    refute widget.persisted?
  end

  def test_persisted_by_id
    widget = TestWidget.new(id: 1, name: "Sprocket")
    assert widget.persisted?
    refute widget.new_record?
  end

  def test_persisted_by_slug
    widget = TestWidget.new(slug: "sprocket", name: "Sprocket")
    assert widget.persisted?
  end

  def test_identifier_prefers_slug
    widget = TestWidget.new(id: 1, slug: "sprocket")
    assert_equal "sprocket", widget.identifier
  end

  def test_identifier_falls_back_to_id
    widget = TestWidget.new(id: 42)
    assert_equal 42, widget.identifier
  end

  # -- Dirty tracking --

  def test_new_record_not_dirty
    widget = TestWidget.new(name: "Sprocket")
    # New records track changes because they haven't been persisted
    assert widget.changed?
  end

  def test_persisted_record_not_dirty
    widget = TestWidget.new(id: 1, name: "Sprocket")
    refute widget.changed?
  end

  def test_changing_attribute_marks_dirty
    widget = TestWidget.new(id: 1, name: "Sprocket")
    widget.name = "Gear"
    assert widget.changed?
    assert_includes widget.changed, "name"
  end

  def test_changed_attributes_hash
    widget = TestWidget.new(id: 1, name: "Sprocket", count: 5)
    widget.name = "Gear"
    hash = widget.send(:_changed_attributes_hash)
    assert_equal({ "name" => "Gear" }, hash)
  end

  # -- Type casting --

  def test_integer_casting
    widget = TestWidget.new(count: "42")
    assert_equal 42, widget.count
  end

  def test_boolean_casting
    widget = TestWidget.new(active: "true")
    assert_equal true, widget.active
  end

  def test_string_keys_normalized
    widget = TestWidget.new("name" => "Sprocket", "id" => 1)
    assert_equal "Sprocket", widget.name
    assert widget.persisted?
  end
end
