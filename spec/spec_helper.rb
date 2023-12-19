# frozen_string_literal: true

require 'rubocop-petal'
require 'rubocop/rspec/support'
require 'rubocop/rspec/shared_contexts/default_rspec_language_config_context'

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense

  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!
  config.raise_on_warning = true
  config.fail_if_no_examples = true

  config.order = :random
  Kernel.srand config.seed

  config.define_derived_metadata(file_path: %r{/spec/rubocop/cop/rspec/}) do |metadata|
    metadata[:type] = :rspec_cop
  end

  config.include_context 'with default RSpec/Language config', type: :rspec_cop
end
