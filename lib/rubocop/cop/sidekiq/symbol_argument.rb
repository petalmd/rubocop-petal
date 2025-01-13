# frozen_string_literal: true

require_relative 'helpers'

# credit: https://github.com/dvandersluis/rubocop-sidekiq/blob/master/lib/rubocop/cop/sidekiq/symbol_argument.rb
module RuboCop
  module Cop
    module Sidekiq
      # This cop checks for symbols passed as arguments to a Sidekiq worker's perform method.
      # Symbols cannot be properly serialized for Redis and should be avoided. Use strings instead.
      #
      # @example
      #   # bad
      #   MyWorker.perform_async(:foo)
      #
      #   # good
      #   MyWorker.perform_async('foo')
      #
      #   # bad
      #   MyWorker.perform_async(foo: 1)
      #
      #   # good
      #   MyWorker.perform_async({'foo' => 1})
      class SymbolArgument < Base
        extend AutoCorrector

        include Helpers

        MSG = 'Symbols are not Sidekiq-serializable; use strings instead.'

        def on_send(node)
          sidekiq_arguments(node).each do |argument|
            if argument.sym_type?
              add_offense(argument) do |corrector|
                corrector.replace(argument, "'#{argument.value}'")
              end
            elsif argument.pair_type?
              if argument.key.sym_type? && argument.value.sym_type?
                add_offense(argument) do |corrector|
                  corrector.replace(argument, "'#{argument.key.value}' => '#{argument.value.value}'")
                end
              elsif argument.key.sym_type?
                add_offense(argument.key) do |corrector|
                  corrector.replace(argument, "'#{argument.key.value}' => #{argument.value.value}")
                end
              elsif argument.value.sym_type?
                add_offense(argument.value) do |corrector|
                  corrector.replace(argument.value, "'#{argument.value.value}'")
                end
              end
            end
          end
        end
      end
    end
  end
end
