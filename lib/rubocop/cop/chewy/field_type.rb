# frozen_string_literal: true

module RuboCop
  module Cop
    module Chewy
      # This cop force to specify a type for Chewy field
      #
      #   # bad
      #   field :name
      #
      #   # good
      #   field :name, type: 'text'
      class FieldType < Base
        MSG = 'Specify a `type` for Chewy field.'

        RESTRICT_ON_SEND = %i[field].freeze

        # @!method options_has_field?(node)
        def_node_matcher :options_has_field?, <<~PATTERN
          (send nil? :field (sym _)+ (hash <(pair (sym :type) {str sym}) ...>))
        PATTERN

        def on_send(node)
          return if options_has_field?(node)

          add_offense(node)
        end
      end
    end
  end
end
