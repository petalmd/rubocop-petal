# frozen_string_literal: true

module RuboCop
  module Cop
    module Grape
      # Prevent usage of `namespace` aliases
      #
      #   # bad:
      #
      #   group :my_group do ... end
      #   resource :my_resource do ... end
      #   resources :my_resources do ... end
      #   segment :my_segment do ... end
      #
      #   # good:
      #
      #   namespace :my_namespace do ... end
      #
      class PreferNamespace < Base
        extend AutoCorrector

        MSG = 'Prefer using `namespace` over its aliases.'

        NAMESPACE_ALIASES = %i[resource resources group segment].freeze
        RESTRICT_ON_SEND = NAMESPACE_ALIASES

        def_node_matcher :using_alias_on_api?, <<~PATTERN
          (send nil? ...)
        PATTERN

        def_node_matcher :namespace_alias, <<~PATTERN
          (send nil? $_ ...)
        PATTERN

        def on_send(node)
          return unless using_alias_on_api? node
          # Check if use block
          return unless node.block_node&.children&.last

          add_offense(node) do |corrector|
            corrector.replace(node, node.source.gsub(/^#{namespace_alias(node)}/, 'namespace'))
          end
        end
      end
    end
  end
end
