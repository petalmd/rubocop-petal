# frozen_string_literal: true

require_relative 'helpers'

module RuboCop
  module Cop
    module Sidekiq
      # This cop checks that Sidekiq job classes with "Job" suffix are placed in the
      # `app/jobs` directory instead of `app/workers` directory.
      # This follows the modern Sidekiq convention where jobs should be organized
      # in the appropriate directory structure.
      #
      # @example
      #   # bad - Job class in app/workers directory
      #   # app/workers/my_job.rb
      #   class MyJob
      #     include Sidekiq::Job
      #   end
      #
      #   # good - Job class in app/jobs directory
      #   # app/jobs/my_job.rb
      #   class MyJob
      #     include Sidekiq::Job
      #   end
      #
      #   # good - Worker class can stay in app/workers (though not recommended)
      #   # app/workers/my_worker.rb
      #   class MyWorker
      #     include Sidekiq::Worker
      #   end
      class JobLocation < Base
        include Helpers

        MSG = 'Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.'

        def on_class(node)
          return unless sidekiq_worker?(node)

          class_name = extract_class_name(node)
          return unless class_name
          return unless class_name.end_with?('Job')

          file_path = processed_source.buffer.name
          return unless file_path.include?('app/workers/')

          add_offense(node.children.first, message: MSG)
        end

        private

        def extract_class_name(node)
          name_node = node.children.first
          return unless name_node&.const_type?

          # Get the last part of the constant name (e.g., "EmailJob" from "MyApp::EmailJob")
          name_node.children.last.to_s
        end
      end
    end
  end
end
