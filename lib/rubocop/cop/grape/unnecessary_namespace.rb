# frozen_string_literal: true

module RuboCop
  module Cop
    module Grape
      # Detect unnecessary usage of Grape namespace.
      #
      #   # bad
      #   namespace :my_namespace
      #     get {}
      #   end
      #
      #   # good
      #   get :my_namespace {}
      #
      class UnnecessaryNamespace < Base
        MSG = 'Unnecessary usage of Grape namespace.'\
              'Specify endpoint name with a argument: `get :my_namespace`.'
        HTTP_ACTIONS = Set.new(%i[get put post patch delete])
        GRAPE_NAMESPACE_ALIAS = Set.new(%i[namespace resource resources])
        METHOD_JUSTIFY_NAMESPACE = Set.new(%i[route_param namespaces resource resources version])

        def_node_matcher :namespace?, <<~PATTERN
          (send nil? GRAPE_NAMESPACE_ALIAS ({sym | str} _))
        PATTERN

        def_node_matcher :justify_namespace?, <<~PATTERN
          (block (send nil? METHOD_JUSTIFY_NAMESPACE ...) ...)
        PATTERN

        def_node_matcher :http_action?, <<~PATTERN
          (block (send nil? HTTP_ACTIONS) ...)
        PATTERN

        def on_send(node)
          return unless namespace?(node)

          node_to_select_http_action = namespace_node(node)

          return if node_to_select_http_action.any? do |namespace_node|
            justify_namespace?(namespace_node)
          end

          http_action_node = select_http_action_block_node(node_to_select_http_action)
          add_offense(node) if http_action_node.size == 1
        end

        def select_http_action_block_node(nodes)
          nodes.select { |node| http_action?(node) }
        end

        def namespace_node(node)
          if node.block_node.children.last.block_type?
            [node.block_node.children.last]
          else
            node.block_node.children.last.children
          end
        end
      end
    end
  end
end
