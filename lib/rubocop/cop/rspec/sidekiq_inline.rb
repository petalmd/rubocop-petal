# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Prevent using `Sidekiq::Testing.inline!` in spec.
      # The method will execute inline every perform_async called.
      # Must likely a spec want to test a specific worker and called it.
      # If you don't need to execute it, consider using `have_enqueued_sidekiq_job`
      # matcher.
      #
      # @example
      #   # bad
      #   Sidekiq::Testing.inline! do; end
      #
      #   # good
      #   expect(MyWorker).to receive(:perform_async).with(some_id) do |id|
      #     MyWorker.new.perform(id)
      #   end
      #
      class SidekiqInline < Base
        MSG = 'Stub `perform_async` and call inline worker with `new.perform`.'
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
