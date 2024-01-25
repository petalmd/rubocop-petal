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
      class SymbolArgument < Base
        include Helpers

        MSG = 'Symbols are not Sidekiq-serializable; use strings instead.'

        def on_send(node)
          sidekiq_arguments(node).select(&:sym_type?).each do |argument|
            add_offense(argument)
          end
        end
      end
    end
  end
end
