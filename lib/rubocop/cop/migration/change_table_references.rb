# frozen_string_literal: true

module RuboCop
  module Cop
    module Migration
      # Prevent using `t.references` or `t.belongs_to` in a change_table.
      # Internally, `t.references` use multiple `ALTER TABLE` statements.
      # Since Rails cannot transform automatically `t.references` inside
      # a `change_table bulk: true` we can manually create the equivalent
      # `ALTER TABLE` statement using `t.bigint`, `t.index` and `t.foreign_key`.
      #
      #   #bad
      #   change_table :subscriptions, bulk: true do |t|
      #     t.references :user, null: false, foreign_key: true
      #   end
      #
      #   #good
      #   change_table :subscriptions, bulk: true do |t|
      #     t.bigint :user_id, null: false
      #     t.index :user_id
      #     t.foreign_key :users, column: :user_id
      #   end
      class ChangeTableReferences < Base
        MSG = 'Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table.'

        # @!method add_references_in_block?(node)
        def_node_search :add_references_in_block?, <<~PATTERN
          (send lvar /references|belongs_to/ ...)
        PATTERN

        # @!method change_table?(node)
        def_node_search :change_table?, <<~PATTERN
          (send nil? :change_table ...)
        PATTERN

        def on_block(node)
          return unless change_table?(node)

          references_node = node.children.detect { |n| add_references_in_block?(n) }
          return unless references_node

          arguments = references_node.child_nodes[1]
          references_methods_range = references_node.source_range.with(end_pos: arguments.source_range.begin_pos - 1)
          add_offense(references_methods_range)
        end
      end
    end
  end
end
