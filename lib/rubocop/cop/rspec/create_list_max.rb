# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Prevent creating to most records with `FactoryBot.create_list`.
      # Creating to much records can significantly increase spec time.
      #
      # @example Max: 5 (default)
      #   # Maximum amount params allowed for `create_list`.
      #
      #   # bad
      #   create_list :my_model, 10
      #
      #   # good
      #   create_list :my_model, 5
      #
      #   # good
      #   build_stubbed_list :my_model, 10
      #
      class CreateListMax < Base
        MSG = 'Creating more than `%<max_config>s` records is discouraged.'
        DEFAULT_MAX = 5
        RESTRICT_ON_SEND = [:create_list].freeze

        def_node_search :create_list, <<~PATTERN
          (send _ :create_list (sym _) (:int $_) ...)
        PATTERN

        def on_send(node)
          amount = create_list(node).to_a.first

          return unless amount

          max_config = cop_config['Max'] || DEFAULT_MAX

          add_offense(node, message: format(MSG, max_config: max_config)) if amount > max_config
        end
      end
    end
  end
end
