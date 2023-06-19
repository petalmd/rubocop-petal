# frozen_string_literal: true

module RuboCop
  module Cop
    module Migration
      # Prevent using `add_reference` and `remove_reference` outside of
      # a `change_table` block. `add_reference` create multiples `ALTER TABLE`
      # statements. Using `change_table` with `bulk: true` is more efficient.
      #
      #  # bad
      #  add_reference :products, :user, foreign_key: true
      #
      #  # good
      #  change_table :products, bulk: true do |t|
      #    t.bigint :user_id, null: false
      #    t.index :user_id
      #    t.foreign_key :users, column: :user_id
      #  end
      class StandaloneAddReference < Base
        MSG = 'Modifying references must be done in a change_table block.'

        RESTRICT_ON_SEND = %i[add_reference belongs_to remove_reference remove_belongs_to].freeze

        def on_send(node)
          reference_method = node.source_range.with(end_pos: node.child_nodes.first.source_range.begin_pos - 1)

          add_offense(reference_method)
        end
      end
    end
  end
end
