# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Prevent using `JSON.parse(response.body)` in spec.
      # Consider using `response.parsed_body`.
      #
      # @example
      #   # bad
      #   JSON.parse(response.body) do; end
      #
      #   # good
      #   response.parsed_body
      #
      class JsonParseResponseBody < Base
        extend AutoCorrector

        MSG = 'Use `response.parsed_body` instead.'

        def_node_matcher :json_parse_response_body?, <<~PATTERN
          (send (const _ :JSON) :parse (send (send _ :response) :body))
        PATTERN

        def on_send(node)
          return unless json_parse_response_body?(node)

          add_offense(node) do |corrector|
            corrector.replace(node, 'response.parsed_body')
          end
        end
      end
    end
  end
end
