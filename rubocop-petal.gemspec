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
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/petalmd/rubocop-petal'
  spec.metadata['rubygems_mfa_required'] = 'true'
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_runtime_dependency 'rubocop', '>= 1.7.0', '< 2.0'
  spec.add_dependency 'rubocop-rails', '~> 2.10.0'
end
