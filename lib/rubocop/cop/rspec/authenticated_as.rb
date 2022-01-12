# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Suggest to use authenticated_as instead of legacy api_key.
      # It is faster, can be setup for multiple test.
      #
      #   # bad
      #   get 'api/my_endpoint', headers: { HTTP_API_KEY: user.api_key }
      #
      #   # good
      #   authenticated_as user
      #   get 'api/my_endpoint'
      #
      class AuthenticatedAs < Base
        MSG = 'Use `authenticated_as` instead of legacy api_key.'

        def_node_search :use_header_api_key, <<~PATTERN
          (sym :HTTP_API_KEY)
        PATTERN

        def on_send(node)
          api_key_usage = use_header_api_key(node).to_a.first
          return unless api_key_usage

          add_offense(api_key_usage)
        end
      end
    end
  end
end
