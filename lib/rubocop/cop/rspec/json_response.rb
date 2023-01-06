# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Prevent using `json_response` in spec.
      # Consider using `response.parsed_body`.
      #
      # @example
      #   # bad
      #   expect(json_response)
      #
      #   # good
      #   expect(response.parsed_body)
      #
      class JsonResponse < Base
        extend AutoCorrector

        MSG = 'Use `response.parsed_body` instead.'

        def_node_matcher :json_response?, <<~PATTERN
          (send _ :json_response)
        PATTERN

        def on_send(node)
          return unless json_response?(node)

          add_offense(node) do |corrector|
            corrector.replace(node, 'response.parsed_body')
          end
        end
      end
    end
  end
end
