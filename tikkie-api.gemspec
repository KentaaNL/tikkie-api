# frozen_string_literal: true

require_relative 'lib/tikkie/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'tikkie-api'
  spec.version       = Tikkie::Api::VERSION
  spec.authors       = %w[Kentaa iRaiser]
  spec.email         = ['tech-arnhem@iraiser.eu']

  spec.summary       = 'Ruby library for communicating with the Tikkie API'
  spec.homepage      = 'https://github.com/KentaaNL/tikkie-api'
  spec.license       = 'MIT'

  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir['LICENSE.txt', 'README.md', 'lib/**/*']

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'jwt', '>= 1.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'timecop', '~> 0.9'
  spec.add_development_dependency 'webmock', '~> 3.18'

  spec.add_dependency 'bigdecimal'
  spec.add_dependency 'logger'
end
