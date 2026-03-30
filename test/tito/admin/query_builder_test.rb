require "test_helper"
require "time"

class Tito::Admin::QueryBuilderTest < Minitest::Test
  def setup
    @qb = Tito::Admin::QueryBuilder.new
  end

  # -- where with arrays --

  def test_where_array_pluralizes_key
    @qb.add_where(state: %w[incomplete unassigned])
    params = @qb.to_params
    assert_equal %w[incomplete unassigned], params["search[states]"]
  end

  def test_where_array_does_not_double_pluralize
    @qb.add_where(states: %w[complete])
    params = @qb.to_params
    assert_equal %w[complete], params["search[states]"]
  end

  # -- where with ranges --

  def test_where_beginless_range
    @qb.add_where(created_at: ..Time.utc(2026, 3, 21, 12, 0, 0))
    params = @qb.to_params
    assert_equal "2026-03-21T12:00:00 UTC", params["search[created_at][lte]"]
    refute params.key?("search[created_at][gte]")
  end

  def test_where_endless_range
    @qb.add_where(created_at: Time.utc(2026, 3, 20, 10, 0, 0)..)
    params = @qb.to_params
    assert_equal "2026-03-20T10:00:00 UTC", params["search[created_at][gte]"]
    refute params.key?("search[created_at][lte]")
  end

  def test_where_both_ended_range
    t1 = Time.utc(2026, 1, 1)
    t2 = Time.utc(2026, 12, 31)
    @qb.add_where(created_at: t1..t2)
    params = @qb.to_params
    assert_equal "2026-01-01T00:00:00 UTC", params["search[created_at][gte]"]
    assert_equal "2026-12-31T00:00:00 UTC", params["search[created_at][lte]"]
  end

  def test_where_exclusive_range_uses_lt
    t1 = Time.utc(2026, 1, 1)
    t2 = Time.utc(2026, 12, 31)
    @qb.add_where(created_at: t1...t2)
    params = @qb.to_params
    assert_equal "2026-01-01T00:00:00 UTC", params["search[created_at][gte]"]
    assert_equal "2026-12-31T00:00:00 UTC", params["search[created_at][lt]"]
  end

  # -- where with scalar --

  def test_where_scalar_value
    @qb.add_where(email: "test@example.com")
    params = @qb.to_params
    assert_equal "test@example.com", params["search[email]"]
  end

  # -- search --

  def test_search_adds_q_param
    @qb.add_search("Jimmy")
    params = @qb.to_params
    assert_equal "Jimmy", params["q"]
  end

  # -- order --

  def test_order_asc
    @qb.add_order(last_name: :asc)
    params = @qb.to_params
    assert_equal "last_name", params["sort"]
  end

  def test_order_desc
    @qb.add_order(last_name: :desc)
    params = @qb.to_params
    assert_equal "-last_name", params["sort"]
  end

  def test_order_multiple_fields
    @qb.add_order(last_name: :asc, created_at: :desc)
    params = @qb.to_params
    assert_equal "last_name,-created_at", params["sort"]
  end

  # -- expand --

  def test_expand_fields
    @qb.add_expand(%i[registration release])
    params = @qb.to_params
    assert_equal "registration,release", params["expand"]
  end

  def test_expand_params_helper
    @qb.add_expand([:release])
    assert_equal({ "expand" => "release" }, @qb.expand_params)
  end

  def test_expand_params_empty_when_none
    assert_equal({}, @qb.expand_params)
  end

  # -- pagination --

  def test_per_page
    @qb.set_per_page(50)
    params = @qb.to_params
    assert_equal 50, params["page[size]"]
  end

  def test_page_number_stored
    @qb.set_page(3)
    assert_equal 3, @qb.page_number
  end

  # -- combined --

  def test_combined_params
    @qb.add_where(state: %w[complete])
    @qb.add_order(last_name: :asc)
    @qb.add_search("Ada")
    @qb.set_per_page(50)

    params = @qb.to_params
    assert_equal %w[complete], params["search[states]"]
    assert_equal "last_name", params["sort"]
    assert_equal "Ada", params["q"]
    assert_equal 50, params["page[size]"]
  end

  # -- dup --

  def test_dup_is_independent
    @qb.add_where(state: %w[complete])
    copy = @qb.dup
    copy.add_where(email: "test@example.com")

    refute @qb.to_params.key?("search[email]")
    assert copy.to_params.key?("search[email]")
  end

  # -- datetime formatting --

  def test_datetime_format_matches_tito_convention
    t = Time.utc(2026, 3, 21, 22, 30, 30)
    @qb.add_where(created_at: t..)
    params = @qb.to_params
    assert_equal "2026-03-21T22:30:30 UTC", params["search[created_at][gte]"]
  end
end
