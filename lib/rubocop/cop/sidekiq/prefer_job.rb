# frozen_string_literal: true

require_relative 'helpers'

module RuboCop
  module Cop
    module Sidekiq
      # This cop checks for the use of `Sidekiq::Worker` and suggests using `Sidekiq::Job` instead.
      # Since Sidekiq 6.3, it is best practice to use `Sidekiq::Job` over `Sidekiq::Worker`.
      #
      # @example
      #   # bad
      #   class MyWorker
      #     include Sidekiq::Worker
      #   end
      #
      #   # good
      #   class MyJob
      #     include Sidekiq::Job
      #   end
      class PreferJob < Base
        extend AutoCorrector

        MSG = 'Prefer `Sidekiq::Job` over `Sidekiq::Worker`.'

        def_node_matcher :sidekiq_worker_include?, <<~PATTERN
          (send nil? :include (const (const {nil? cbase} :Sidekiq) :Worker))
        PATTERN

        def on_send(node)
          return unless sidekiq_worker_include?(node)

          add_offense(node, message: MSG) do |corrector|
            corrector.replace(node.arguments.first, 'Sidekiq::Job')
          end
        end
      end
    end
  end
end
