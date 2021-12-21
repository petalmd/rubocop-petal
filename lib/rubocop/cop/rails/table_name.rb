# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # This cop enforces the absence of explicit table name definitions.
      #
      #   # bad
      #   self.table_name = 'some_table_name'
      #   self.table_name = :some_other_name
      class TableName < Base
        include ActiveRecordHelper

        MSG = %{
Avoid using `self.table_name=` if at all possible. When ActiveRecord's defaults are used, it may be omitted.
If you are working on a new model, you should name the table and model to fit the defaults
If you absolutely must use it, disable the cop with `# rubocop:disable Rails/TableName`
        }

        def on_send(node)
          add_offense(node) if find_set_table_name(node).to_a.any?
        end
      end
    end
  end
end
