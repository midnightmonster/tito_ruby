require "test_helper"

class Tito::Admin::ClientTest < Minitest::Test
  def test_requires_token
    assert_raises(Tito::Errors::ConfigurationError) do
      Tito::Admin::Client.new(account: "demo")
    end
  end

  def test_requires_account
    assert_raises(Tito::Errors::ConfigurationError) do
      Tito::Admin::Client.new(token: "test")
    end
  end

  def test_uses_global_configuration
    Tito.configure do |c|
      c.token = "global-token"
      c.account = "global-account"
    end

    client = Tito::Admin::Client.new
    assert_equal "global-token", client.token
    assert_equal "global-account", client.account
  ensure
    Tito.reset_configuration!
  end

  def test_explicit_params_override_global
    Tito.configure do |c|
      c.token = "global-token"
      c.account = "global-account"
    end

    client = Tito::Admin::Client.new(token: "local", account: "local-acct")
    assert_equal "local", client.token
    assert_equal "local-acct", client.account
  ensure
    Tito.reset_configuration!
  end

  def test_events_returns_collection_proxy
    client = Tito::Admin::Client.new(token: "test", account: "demo")
    assert_instance_of Tito::Admin::CollectionProxy, client.events
  end

  def test_tickets_returns_collection_proxy
    client = Tito::Admin::Client.new(token: "test", account: "demo", event: "conf")
    assert_instance_of Tito::Admin::CollectionProxy, client.tickets
  end

  def test_event_scoped_resource_without_event_raises
    client = Tito::Admin::Client.new(token: "test", account: "demo")
    assert_raises(Tito::Errors::ConfigurationError) { client.tickets }
  end

  def test_event_scoped_resource_with_override
    client = Tito::Admin::Client.new(token: "test", account: "demo")
    proxy = client.tickets(event: "conf-2026")
    assert_instance_of Tito::Admin::CollectionProxy, proxy
  end

  def test_all_resource_accessors_exist
    client = Tito::Admin::Client.new(token: "test", account: "demo", event: "conf")
    %i[events tickets releases registrations activities questions
       discount_codes checkin_lists opt_ins interested_users
       rsvp_lists waitlisted_people venues webhook_endpoints].each do |method|
      assert_respond_to client, method, "Client should respond to ##{method}"
    end
  end
end
