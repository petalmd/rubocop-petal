# frozen_string_literal: true

require 'rubocop'

module Rubocop
  module Cop
    module Worker
      # Ensure workers avoid using early nil returns.
      #
      # # bad
      # def perform
      #   return if condition
      #   ...
      # end
      #
      # # good
      # def perform
      #   # TDB, idea would be `raise SilentError if condition``
      # end
      class NoNilReturn < Base
        MSG = 'Avoid using early nil return in workers'

        def_node_matcher :method_definition?, <<~PATTERN
          (def ...)
        PATTERN

        def_node_matcher :nil_return?, <<~PATTERN
          (:return nil?)
        PATTERN

        def on_send(node)
          node.body.each_node do |child_node|
            next unless child_node.begin_type?

            child_node.children.each do |grandchild_node|
              add_offense(grandchild_node) if nil_return_value?(grandchild_node)
            end
          end
        end

        private

        # def nil_return?(node)
        #   children = node.child_nodes.select do |child|
        #     nil_return_value?(child)
        #   end

        #   children.any?
        # end

        def nil_return_value?(node)
          return unless node.return_type?

          node.children.empty? || node.children.first&.nil_type?
        end
      end
    end
  end
end
