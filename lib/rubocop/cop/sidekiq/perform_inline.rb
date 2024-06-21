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
        MSG = 'Use `perform_inline` instead of `new.perform`.'

        RESTRICT_ON_SEND = %i[perform].freeze

        # @!method new_perform?(node)
        def_node_matcher :new_perform?, <<~PATTERN
          (send (send (const nil? _) :new) :perform)
        PATTERN

        def on_send(node)
          return unless new_perform?(node)

          add_offense(node)
        end

        def autocorrect(node)
          lambda do |corrector|
            receiver, _method_name = *node
            corrector.replace(receiver.source_range,
                              receiver.source_range.source.gsub('new.perform', 'perform_inline'))
          end
        end
      end
    end
  end
end
