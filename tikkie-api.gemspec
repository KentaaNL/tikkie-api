# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tikkie/api/version"

Gem::Specification.new do |spec|
  spec.name          = "tikkie-api"
  spec.version       = Tikkie::Api::VERSION
  spec.authors       = ["Kentaa BV"]
  spec.email         = ["support@kentaa.nl"]

  spec.summary       = "Ruby library for communicating with the Tikkie API"
  spec.homepage      = "https://github.com/KentaaNL/tikkie-api"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jwt", ">= 1.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop", "~> 0.9"
  spec.add_development_dependency "webmock", "~> 2.3"
end
