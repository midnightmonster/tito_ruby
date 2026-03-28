require "test_helper"

class OptInsIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_opt_ins
    VCR.use_cassette("integration/opt_ins_list") do
      opt_ins = @client.opt_ins.to_a
      assert opt_ins.any?, "Expected at least one opt in"

      opt_in = opt_ins.first
      assert_kind_of Tito::Admin::Resources::OptIn, opt_in
      assert opt_in.id
      assert opt_in.slug
      assert opt_in.name
    end
  end

  def test_create_and_delete_opt_in
    VCR.use_cassette("integration/opt_ins_crud") do
      opt_in = @client.opt_ins.create(
        name: "Integration Test Opt In",
        description: "Created by integration test"
      )
      assert opt_in.persisted?
      assert opt_in.id
      assert_equal "Integration Test Opt In", opt_in.name

      opt_in.destroy
      assert opt_in.destroyed?
    end
  end
end
