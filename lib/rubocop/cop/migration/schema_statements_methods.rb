# frozen_string_literal: true

module RuboCop
  module Cop
    module Migration
      # Use SchemaStatements methods already defined in a migration class.
      # Using already defined method is sorter and will be log during migration.
      #
      #   # bad
      #   ActiveRecord::Base.connection.table_exists? 'users'
      #
      #   # bad
      #   ActiveRecord::Base.connection.column_exists? 'users', 'first_name'
      #
      #   # bad
      #   ApplicationRecord.connection.execute('SELECT COUNT(*) FROM `users`')
      #
      #   # good
      #   table_exists? 'users'
      #
      #   # good
      #   column_exists? 'users', 'first_name'
      #
      #   # good
      #   execute('SELECT COUNT(*) FROM `users`')
      #
      class SchemaStatementsMethods < Base
        extend AutoCorrector

        MSG = 'Use already defined methods. Remove `ActiveRecord::Base.connection`.'

        def_node_matcher :use_connection, <<~PATTERN
          (:send (... (:const ...) :connection) ...)
        PATTERN

        def on_send(node)
          return unless use_connection(node)

          add_offense(node.children[0]) do |corrector|
            corrector.replace(node, node.source.gsub("#{node.children[0].source}.", ''))
          end
        end
      end
    end
  end
end
