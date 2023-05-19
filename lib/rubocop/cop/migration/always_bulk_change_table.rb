# frozen_string_literal: true

module RuboCop
  module Cop
    module Migration
      # Using `bulk: true` with `change_table` is recommended.
      # Without `bulk: true`, `change_table` generates multiple
      # `ALTER TABLE` statements and the migration process will
      # be duplicated.
      #
      # @bad
      #   change_table :users do |t|
      #     t.string :first_name
      #     t.string :last_name
      #   end
      #
      # @good
      #  change_table :users, bulk: true do |t|
      #    t.string :first_name
      #    t.string :last_name
      #  end
      #
      class AlwaysBulkChangeTable < Rails::BulkChangeTable
        MSG = 'Add `bulk: true` when using change_table.'
        RESTRICT_ON_SEND = %i[change_table].freeze

        def on_send(node)
          return unless node.command?(:change_table)

          unless include_bulk_options?(node)
            add_offense(node)
            return
          end

          add_offense(node) unless bulk_options_true?(node)
        end

        def bulk_options_true?(node)
          options = node.arguments[1]
          options.each_pair do |key, value|
            return true if key.value == :bulk && value.true_type?
          end
          false
        end
      end
    end
  end
end
