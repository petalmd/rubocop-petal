# frozen_string_literal: true

require_relative 'lib/rubocop/petal/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-petal'
  spec.version       = RuboCop::Petal::VERSION
  spec.authors       = ['Jean-Francis Bastien']
  spec.email         = ['jfbastien@petalmd.com']

  spec.summary       = 'Petal custom cops'
  spec.homepage      = 'https://github.com/petalmd/rubocop-petal'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7')

  spec.files = Dir['LICENSE.txt', 'README.md', 'config/**/*', 'lib/**/*']
  spec.extra_rdoc_files = %w[LICENSE.txt README.md]
  spec.require_paths = ['lib']

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'changelog_uri' => 'https://github.com/petalmd/rubocop-petal/blob/main/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/petalmd/rubocop-petal',
    'bug_tracker_uri' => 'https://github.com/petalmd/rubocop-petal/issues',
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'rubocop', '~> 1.70'
  spec.add_dependency 'rubocop-factory_bot', '~> 2.26'
  spec.add_dependency 'rubocop-performance', '~> 1.23'
  spec.add_dependency 'rubocop-rails', '~> 2.28'
  spec.add_dependency 'rubocop-rspec', '~> 3.3'
  spec.add_dependency 'rubocop-rspec_rails', '~> 2.30'
end
