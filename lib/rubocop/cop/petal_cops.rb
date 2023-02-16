# frozen_string_literal: true

require 'rubocop'
require 'rubocop-rails'

# Require mixin first
mixins_glob = File.join(__dir__, 'mixin', '**', '*.rb')
Dir[mixins_glob].sort.each { |cop| require(cop) }

# Auto-require all cops under `rubocop/cop/**/*.rb`
cops_glob = File.join(__dir__, '**', '*.rb')
Dir[cops_glob].sort.each { |cop| require(cop) }
