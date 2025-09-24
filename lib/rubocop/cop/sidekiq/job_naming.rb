# frozen_string_literal: true

require_relative 'helpers'

module RuboCop
  module Cop
    module Sidekiq
      # This cop checks that Sidekiq job class names end with "Job" instead of "Worker".
      # Since Sidekiq 6.3, it is best practice to use "Job" terminology over "Worker".
      #
      # @example
      #   # bad
      #   class MyWorker
      #     include Sidekiq::Job
      #   end
      #
      #   class ProcessDataWorker
      #     include Sidekiq::Worker
      #   end
      #
      #   # good
      #   class MyJob
      #     include Sidekiq::Job
      #   end
      #
      #   class ProcessDataJob
      #     include Sidekiq::Job
      #   end
      class JobNaming < Base
        include Helpers

        MSG = 'Job class name should end with `Job` instead of `Worker`.'

        def_node_matcher :class_name, <<~PATTERN
          (class (const _ $_) ...)
        PATTERN

        def on_class(node)
          return unless sidekiq_worker?(node)

          class_name = extract_class_name(node)
          return unless class_name
          return unless class_name.end_with?('Worker')

          add_offense(node.children.first, message: MSG)
        end

        private

        def extract_class_name(node)
          name_node = node.children.first
          return unless name_node&.const_type?

          # Get the last part of the constant name (e.g., "EmailWorker" from "MyApp::EmailWorker")
          name_node.children.last.to_s
        end
      end
    end
  end
end
