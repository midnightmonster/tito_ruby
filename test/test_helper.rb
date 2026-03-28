require "dotenv"
Dotenv.load(File.expand_path("../.env", __dir__))

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "tito"

require "minitest/autorun"
require "vcr"
require "webmock/minitest"

TITO_TEST_TOKEN   = ENV.fetch("TITO_TOKEN", "<TITO_TOKEN>")
TITO_TEST_ACCOUNT = ENV.fetch("TITO_ACCOUNT", "<TITO_ACCOUNT>")
TITO_TEST_EVENT   = "test-event-1"

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path("cassettes", __dir__)
  config.hook_into :webmock
  config.filter_sensitive_data("<TITO_TOKEN>") { TITO_TEST_TOKEN }
  config.filter_sensitive_data("<TITO_ACCOUNT>") { TITO_TEST_ACCOUNT }
  config.default_cassette_options = { record: :once }
end

# Allow non-VCR tests to use Faraday test adapter without WebMock interference
WebMock.allow_net_connect!
