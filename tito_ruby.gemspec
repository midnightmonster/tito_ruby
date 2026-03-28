require_relative "lib/tito/version"

Gem::Specification.new do |spec|
  spec.name          = "tito_ruby"
  spec.version       = Tito::VERSION
  spec.authors       = ["Joshua Paine"]
  spec.summary       = "Ruby client for the Tito Admin API v3.1"
  spec.description   = "A Ruby client library for the Tito event management Admin API (v3). Supports events, tickets, registrations, releases, and more."
  spec.homepage      = "https://github.com/midnightmonster/tito_ruby"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1"

  spec.metadata = {
    "source_code_uri"       => spec.homepage,
    "changelog_uri"         => "https://github.com/midnightmonster/tito_ruby/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "activemodel", ">= 7.1", "< 9.0"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "dotenv", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
