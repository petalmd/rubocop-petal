# frozen_string_literal: true

module RuboCop
  module Cop
    module Migration
      # Use `bulk: true` with `change_table`.
      # # bad
      #
      # change_table :my_table
      #
      # # good
      #
      # change_table :my_table, bulk: true
      class UseChangeTableBulk < Base
        MSG = 'Use `change_table` with `bulk: true`.'
        RESTRICT_ON_SEND = %i[change_table].freeze

        def_node_matcher :use_bulk?, <<~PATTERN
          (send nil? :change_table _ (hash <(pair (sym :bulk) true) ...>) ...)
        PATTERN

        def on_send(node)
          return if use_bulk?(node)

          add_offense(node)
        end
      end
    end
  end
end
