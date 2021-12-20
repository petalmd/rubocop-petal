# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/petal'
require_relative 'rubocop/petal/version'
require_relative 'rubocop/petal/inject'

RuboCop::Petal::Inject.defaults!

require_relative 'rubocop/cop/petal_cops'
