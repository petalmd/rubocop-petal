# frozen_string_literal: true

module RuboCop
  module Cop
    module Sidekiq
      # Suggest to use `perform_inline` instead of `new.perform` for Sidekiq workers.
      #
      # @bad
      #   MyWorker.new.perform
      #
      # @good
      #   MyWorker.perform_inline
      #
      class PerformInline < Base
        extend AutoCorrector
        MSG = 'Use `perform_inline` instead of `new.perform`'

        RESTRICT_ON_SEND = %i[perform].freeze

        # @!method new_perform?(node)
        def_node_matcher :new_perform?, <<~PATTERN
          (send (send _ :new) :perform ...)
        PATTERN

        def on_send(node)
          return unless new_perform?(node)

          new_perform_node = node.source_range.with(
            begin_pos: node.receiver.receiver.source_range.end_pos + 1,
            end_pos: node.loc.selector.end_pos
          )

          add_offense(new_perform_node) do |corrector|
            corrector.replace(new_perform_node, 'perform_inline')
          end
        end
      end
    end
  end
end
