# frozen_string_literal: true

require 'rubocop'
require 'rubocop-rails'

# Auto-require all cops under `rubocop/cop/**/*.rb`
cops_glob = File.join(__dir__, '**', '*.rb')
Dir[cops_glob].sort.each { |cop| require(cop) }
require_relative 'rspec/sidekiq_perform_matcher'
