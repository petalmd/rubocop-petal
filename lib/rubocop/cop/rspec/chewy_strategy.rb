# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Prevent to change the Chewy strategy in tests.
      # Setting the strategy to atomic may try to import unnecessary data
      # for the test which result to a slower test suite.
      #
      # @example 
      #   # bad
      #   let(:user) { Chewy.strategy(:atomic) { create(:user) } }
      #
      #   # good
      #   let(:user) { create(:user) }
      #   before { UserIndex.import! user }
      #
      class ChewyStrategy < Base
        MSG = 'Do not use Chewy.strategy in tests. Import data explicitly instead.'
        RESTRICT_ON_SEND = %i[strategy].freeze

        # @!method chewy_strategy?(node)
        def_node_matcher :chewy_strategy?, <<~PATTERN
          (send (const nil? :Chewy) :strategy ...)
        PATTERN

        def on_send(node)
          return unless chewy_strategy?(node)

          add_offense(node)
        end
        alias on_csend on_send
      end
    end
  end
end
