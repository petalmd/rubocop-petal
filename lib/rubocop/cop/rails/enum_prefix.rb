# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # Enforces the use of `_prefix` with any enum.
      # Using a prefix helps prevent overriding of existing methods
      # Example: enum some_enum: { open: 0, each: 1 }
      #
      # Will cause an error because of overlap with existing methods such as `open` and `each`
      # For more information, see https://github.com/rails/rails/issues/13389#issue-24527737
      #
      #   # bad
      #   enum my_enum: {some_value: 0, another: 1}
      #
      #   # good
      #   enum my_enum: {some_value: 0, another: 1}, _prefix: true
      #
      #   # good
      #   enum my_enum: {some_value: 0, another: 1}, _prefix: :my_prefix
      #
      #   # good
      #   enum my_enum: {some_value: 0, another: 1}, _suffix: true
      #
      #   # good
      #   enum my_enum: {some_value: 0, another: 1}, _suffix: 'another_suffix'
      class EnumPrefix < Base
        MSG = 'Prefer using a `_prefix` or `_suffix` with `enum`.'

        def_node_matcher :enum?, <<~PATTERN
          (send nil? :enum (hash ...))
        PATTERN

        def_node_matcher :use_prefix_or_suffix?, <<~PATTERN
          (send nil? :enum (hash <(pair (sym {:_prefix :_suffix}) {true str sym}) ...>))
        PATTERN

        def on_send(node)
          return unless enum? node

          add_offense(node) unless use_prefix_or_suffix? node
        end
      end
    end
  end
end
