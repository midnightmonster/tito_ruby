require "test_helper"

class DiscountCodesIntegrationTest < Minitest::Test
  def setup
    @client = Tito::Admin::Client.new(
      token: TITO_TEST_TOKEN,
      account: TITO_TEST_ACCOUNT,
      event: TITO_TEST_EVENT
    )
  end

  def test_list_discount_codes
    VCR.use_cassette("integration/discount_codes_list") do
      codes = @client.discount_codes.to_a
      assert codes.any?, "Expected at least one discount code"

      code = codes.first
      assert_kind_of Tito::Admin::Resources::DiscountCode, code
      assert code.id
      assert code.code
      assert code.state
      assert code.type
      assert code.value
      assert code.share_url
    end
  end

  def test_create_and_delete_discount_code
    VCR.use_cassette("integration/discount_codes_crud") do
      code = @client.discount_codes.create(
        code: "INTEGRATIONTEST",
        type: "PercentOffDiscountCode",
        value: 25
      )
      assert code.persisted?
      assert code.id
      assert_equal "INTEGRATIONTEST", code.code
      assert_equal "PercentOffDiscountCode", code.type

      code.destroy
      assert code.destroyed?
    end
  end
end
