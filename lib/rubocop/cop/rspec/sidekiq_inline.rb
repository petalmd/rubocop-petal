# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Prevent using `Sidekiq::Testing.inline!` in spec.
      # The method will execute inline every perform_async called.
      # Must likely a spec want to test a specific worker and called it.
      # If you don't need to execute it, consider using `have_enqueued_sidekiq_job`
      # matcher. Or if you need to perform the jobs in queue for this worker, use
      # `drain` method on the worker class.
      #
      # @example
      #   # bad
      #   Sidekiq::Testing.inline! do
      #      OperationThatTriggerWorker.call(some_id)
      #   end
      #
      #   # good
      #   OperationThatTriggerWorker.call(some_id)
      #   MyWorker.drain
      #
      class SidekiqInline < Base
        MSG = 'Use `MyWorker.drain` method instead of `Sidekiq::Testing.inline!`.'
        RESTRICT_ON_SEND = [:inline!].freeze

        def_node_matcher :sidekiq_inline?, <<~PATTERN
          (send (const (const _ :Sidekiq) :Testing) :inline!)
        PATTERN

        def on_send(node)
          return unless sidekiq_inline?(node)

          add_offense(node)
        end
      end
    end
  end
end
