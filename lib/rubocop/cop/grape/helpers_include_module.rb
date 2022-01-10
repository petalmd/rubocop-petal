# frozen_string_literal: true

module RuboCop
  module Cop
    module Grape
      # Prevent usage of Grape `helpers` with a block to include module.
      # Using a bloc will create a new unnecessary module.
      #
      #   # bad
      #   helpers do
      #     include MyModule
      #   end
      #
      #   # bad
      #   helpers do
      #     include MyModule
      #     include MyOtherModule
      #   end
      #
      #   # good
      #   helpers MyModule
      #
      #   # good
      #   helpers MyModule, MyOtherModule
      class HelpersIncludeModule < Base
        MSG = 'Use `helpers %<module_name>s` instead of `helpers` with a block.'

        def_node_matcher :helpers?, <<~PATTERN
          (send nil? :helpers)
        PATTERN

        def_node_matcher :called_include?, <<~PATTERN
          (send nil? :include (const _ $_))
        PATTERN

        def on_send(node)
          return unless helpers?(node)

          helpers_block_node = node.block_node.children.last
          block_nodes = block_nodes_in_helpers(helpers_block_node)

          block_nodes.each do |block_node|
            if (module_name = called_include?(block_node))
              add_offense(block_node, message: format(MSG, module_name: module_name))
            end
          end
        end

        private

        def block_nodes_in_helpers(node)
          if node.begin_type?
            node.children
          else
            [node]
          end
        end
      end
    end
  end
end
