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
      #   MyWorker.perform_async("foo")
      #
      #   # bad
      #   MyWorker.perform_async(%i(foo))
      #
      #   # good
      #   MyWorker.perform_async(%w(foo))
      #
      #   # bad
      #   MyWorker.perform_async([:foo])
      #
      #   # good
      #   MyWorker.perform_async(["foo"]))
      #
      #   # bad
      #   MyWorker.perform_async(foo: 1)
      #
      #   # good
      #   MyWorker.perform_async('foo' => 1)
      #
      #   # bad
      #   MyWorker.perform_async('foo' => :baz)
      #
      #   # good
      #   MyWorker.perform_async('foo' => "baz")
      #
      #   # bad
      #   MyWorker.perform_async('foo' => [:bar]
      #
      #   # good
      #   MyWorker.perform_async('foo' => ["baz"])
      #
      #   # bad
      #   MyWorker.perform_async('foo' => %i(baz)
      #
      #   # good
      #   MyWorker.perform_async('foo' => %w(baz))
      #
      #   # bad
      #   MyWorker.perform_async('foo' => { bar: %i(baz) })
      #
      #   # good
      #   MyWorker.perform_async('foo' => { bar: %w(baz) })
      #
      #   # bad
      #   MyWorker.perform_async('foo' => { bar: [:baz]) })
      #
      #   # good
      #   MyWorker.perform_async('foo' => { bar: ["baz"] })
      #
      class SymbolArgument < Base
        extend AutoCorrector

        include Helpers

        MSG = 'Symbols are not native JSON types; use strings instead.'

        def on_send(node)
          sidekiq_arguments(node)
            .lazy
            .select { |n| node_contains_symbol?(n) }
            .each do |selected_node|
            offense_data(selected_node) do |offense_node, replace_node, replace_value|
              add_offense(offense_node) do |corrector|
                corrector.replace(replace_node, replace_value)
              end
            end
          end
        end

        private

        def node_contains_symbol?(node)
          node.sym_type? || symbol_percent_literal?(node) || pair_with_symbol?(node)
        end

        def symbol_percent_literal?(node)
          node.array_type? && node.percent_literal?(:symbol)
        end

        def pair_with_symbol?(node)
          node.pair_type? && (node.key.sym_type? || node.value.sym_type?)
        end

        def offense_data(node)
          yield sym_replace_value(node) || array_replace_value(node) || pair_replace_value(node)
        end

        def sym_replace_value(node)
          return unless node.sym_type?

          [node, node, %("#{node.value}")]
        end

        def array_replace_value(node)
          return unless node.array_type?

          [node, node, "%w(#{node.values.map(&:value).join(' ')})"]
        end

        def pair_replace_value(node)
          return unless node.pair_type?

          pair_both_symbol(node) || pair_only_key_symbol(node) || pair_only_value_symbol(node)
        end

        def pair_both_symbol(node)
          return unless node.key.sym_type? && node.value.sym_type?

          [node, node, %("#{node.key.value}" => "#{node.value.value}")]
        end

        def pair_only_key_symbol(node)
          return unless node.key.sym_type?

          [node.key, node, %("#{node.key.value}" => #{node.value.source})]
        end

        def pair_only_value_symbol(node)
          return unless node.value.sym_type?

          [node.value, node.value, %("#{node.value.value}")]
        end
      end
    end
  end
end
