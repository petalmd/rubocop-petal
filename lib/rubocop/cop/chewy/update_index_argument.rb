# frozen_string_literal: true

module RuboCop
  module Cop
    module Chewy
      # This cop checks for the use of block with single expression in `update_index` method
      # and suggests to use method symbol as second argument instead of block.
      #
      # # bad
      # update_index('index_name') { self }
      #
      # # good
      # update_index('index_name', :self)
      #
      class UpdateIndexArgument < Base
        extend AutoCorrector

        MSG = 'Use method symbol as second argument instead of block.'

        RESTRICT_ON_SEND = %i[update_index].freeze

        def_node_matcher :block_with_single_expression?, <<~PATTERN
          (block
            (send nil? :update_index (str _) $...)
            (args)
            $...)
        PATTERN

        def on_block(node)
          block_with_single_expression?(node) do |existing_args, method_name|
            return if method_name.last.children.compact.size > 1

            method_name = method_name.first.source
            add_offense(node.loc.expression) do |corrector|
              corrector.replace(node.loc.expression, corrected_code(node, existing_args, method_name))
            end
          end
        end

        private

        def corrected_code(node, existing_args, method_name)
          method_call = node.children[0] # The update_index method call
          index_name = method_call.children[2].source

          if existing_args.any?
            # If there are additional arguments (like if: :update?), insert method_name before them
            "update_index(#{index_name}, :#{method_name}, #{existing_args.map(&:source).join(', ')})"
          else
            # If no additional arguments, simply add method_name as the second argument
            "update_index(#{index_name}, :#{method_name})"
          end
        end
      end
    end
  end
end
