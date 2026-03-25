require_relative "lib/tito/version"

Gem::Specification.new do |spec|
  spec.name          = "tito_ruby"
  spec.version       = Tito::VERSION
  spec.authors       = ["Joshua"]
  spec.summary       = "Ruby client for the Tito Admin API v3.1"
  spec.homepage      = "https://github.com/joshuap/tito_ruby"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "activemodel", ">= 7.0"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "dotenv", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
