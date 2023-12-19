# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # Prevent the user to start from Zero with an enum.
      # When using a wrong value like .where(state: :patato) let Rails + MySQL do a WHERE state = 0.
      # It will match nothing since no record will have a 0 value.
      #
      #   # bad
      #   enum my_enum: {apple: 0, bannana: 1}
      #
      #   # good
      #   enum my_enum: {apple: 1, banana: 2}

      class EnumStartingValue < Base
        MSG = 'Prefer starting from `1` instead of `0` with `enum`.'

        def_node_matcher :enum?, <<~PATTERN
          (send nil? :enum (hash ...))
        PATTERN

        def_node_matcher :enum_attributes, <<~PATTERN
          (send nil? :enum (:hash (:pair (...)$(...) )...))
        PATTERN

        def on_send(node)
          return unless enum? node

          add_offense(node) if start_with_zero?(enum_attributes(node))
        end

        def start_with_zero?(node)
          return false unless node.type == :hash

          node.children.any? do |child|
            value = child.value
            value.type == :int && value.value.zero?
          end
        end
      end
    end
  end
end
