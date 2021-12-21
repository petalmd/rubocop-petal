# frozen_string_literal: true

module RuboCop
  module Cop
    module Chewy
      # This cop prevent usage of table_name= to in favor of convention.
      #
      #   # bad
      #   UsersIndex::User.reset!
      #
      #   # good
      #   UsersIndex.reset!
      class ResetOnType < Base
        MSG = 'Using reset or reset! on the type instead of the index will put Elasticsearch in an unhealthy state'

        def_node_matcher :reset_on_type?, <<~PATTERN
          (const (const ... #index?) _)
        PATTERN

        def on_send(node)
          receiver, method_name, *_args = *node
          return unless %i[reset reset!].include? method_name

          return unless reset_on_type?(receiver)

          add_offense(node)
        end

        private

        def index?(sym)
          sym.to_s.end_with?('Index')
        end
      end
    end
  end
end
