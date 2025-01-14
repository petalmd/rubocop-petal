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
            manage_sym_type(argument) || manage_pair_type(argument)
          end
        end

        private

        def manage_sym_type(argument)
          return unless argument.sym_type?

          add_offense(argument) do |corrector|
            corrector.replace(argument, "'#{argument.value}'")
          end
        end

        def manage_pair_type(argument)
          return unless argument.pair_type?

          manage_pair_key_value_symbol(argument) ||
            manage_pair_key_symbol(argument) ||
            manage_pair_value_symbol(argument)
        end

        def manage_pair_key_value_symbol(argument)
          return unless argument.key.sym_type? && argument.value.sym_type?

          add_offense(argument) do |corrector|
            corrector.replace(argument, "'#{argument.key.value}' => '#{argument.value.value}'")
          end
        end

        def manage_pair_key_symbol(argument)
          return unless argument.key.sym_type?

          add_offense(argument.key) do |corrector|
            value = argument.value
            not_value_type = value.lvar_type? || value.send_type? || value.block_type?
            corrected_value = not_value_type ? value.source : value.value
            corrector.replace(argument, "'#{argument.key.value}' => #{corrected_value}")
          end
        end

        def manage_pair_value_symbol(argument)
          return unless argument.value.sym_type?

          add_offense(argument.value) do |corrector|
            corrector.replace(argument.value, "'#{argument.value.value}'")
          end
        end
      end
    end
  end
end
