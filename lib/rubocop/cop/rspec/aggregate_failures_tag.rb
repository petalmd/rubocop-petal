# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Checks that the `:aggregate_failures` tag is only used on examples,
      # not on example groups.
      #
      # The `:aggregate_failures` tag only works on individual examples (`it`, `specify`, etc.),
      # not on example groups (`describe`, `context`, etc.).
      #
      # @example
      #   # bad
      #   describe '#enabled?', :aggregate_failures do
      #     # ...
      #   end
      #
      #   context 'when enabled', :aggregate_failures do
      #     # ...
      #   end
      #
      #   # good
      #   it 'returns true', :aggregate_failures do
      #     # ...
      #   end
      #
      #   specify 'the behavior', :aggregate_failures do
      #     # ...
      #   end
      #
      class AggregateFailuresTag < Base
        MSG = 'The `:aggregate_failures` tag should only be used on examples, not on example groups.'

        EXAMPLE_METHODS = %i[
          it
          specify
          example
          scenario
          its
          fit
          fspecify
          fexample
          fscenario
          focus
          xit
          xspecify
          xexample
          xscenario
          skip
          pending
        ].freeze

        RSPEC_METHODS = %i[
          describe
          context
          feature
          example_group
          xdescribe
          fdescribe
          it
          specify
          example
          scenario
          its
          fit
          fspecify
          fexample
          fscenario
          focus
          xit
          xspecify
          xexample
          xscenario
          skip
          pending
        ].freeze

        def on_block(node)
          return unless rspec_block?(node)
          return unless aggregate_failures_tag?(node)
          return if example_method?(node)

          # Create a range that includes the method call up to and including the 'do' keyword
          send_node = node.send_node
          range = send_node.source_range.join(node.loc.begin)
          add_offense(range)
        end

        private

        def rspec_block?(node)
          send_node = node.send_node
          return false unless send_node
          return false unless send_node.send_type?

          RSPEC_METHODS.include?(send_node.method_name)
        end

        def example_method?(node)
          send_node = node.send_node
          return false unless send_node

          EXAMPLE_METHODS.include?(send_node.method_name)
        end

        def aggregate_failures_tag?(node)
          send_node = node.send_node
          return false unless send_node

          send_node.arguments.any? do |arg|
            if arg.sym_type? && arg.value == :aggregate_failures
              true
            elsif arg.hash_type?
              arg.pairs.any? { |pair| pair.key.sym_type? && pair.key.value == :aggregate_failures }
            else
              false
            end
          end
        end
      end
    end
  end
end
