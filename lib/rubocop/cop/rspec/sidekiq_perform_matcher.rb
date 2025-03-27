# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Prevent the use of `receive(:perform_async)` matcher to
      # use instead rspec-sidekiq matcher like `enqueue_sidekiq_job`.
      #
      # @example
      #   # bad
      #   expect(MyWorker).to receive(:perform_async).with(args)
      #   expect(MyWorker).to receive(:perform_in).with(5.seconds, args)
      #   expect(MyWorker).to receive(:perform_at).with(specific_time, args)
      #   expect(MyWorker).to receive(:perform_bulk)
      #
      #   # good
      #   expect(MyWorker).to have_enqueued_sidekiq_job.with(args)
      #   expect(MyWorker).to have_enqueued_sidekiq_job.in(1.seconds).with(args)
      #   expect(MyWorker).to have_enqueued_sidekiq_job.at(specific_time).with(args)
      #   expect(MyWorker).to have_enqueued_sidekiq_job
      #
      class SidekiqPerformMatcher < Base
        MSG = 'Use `have_enqueued_sidekiq_job` instead of `receive(:perform_%s)`.'
        RESTRICT_ON_SEND = %i[receive].freeze

        # @!method perform_matcher?(node)
        def_node_matcher :perform_matcher?, <<~PATTERN
          (send nil? :receive (sym {:perform_async :perform_in :perform_at :perform_bulk}))
        PATTERN

        def on_send(node)
          return unless perform_matcher?(node)

          perform_method = node.first_argument.value.to_s.sub('perform_', '')

          add_offense(node, message: format(MSG, perform_method))
        end
        alias on_csend on_send
      end
    end
  end
end
