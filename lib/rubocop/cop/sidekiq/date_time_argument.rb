# frozen_string_literal: true

require_relative 'helpers'

# credit: https://github.com/dvandersluis/rubocop-sidekiq/blob/master/lib/rubocop/cop/sidekiq/date_time_argument.rb
module RuboCop
  module Cop
    module Sidekiq
      # This cop checks for date/time objects being passed as arguments to perform a Sidekiq
      # worker. Dates, times, durations, and related classes cannot be serialized to Redis.
      # Use an integer or string representation of the date/time instead.
      #
      # By default, this only allows `to_i` and `to_s` as valid, serializable methods for these
      # classes. Use `AllowedMethods` to specify other allowed methods.
      #
      # @example
      #   # bad
      #   MyWorker.perform_async(Time.now)
      #   MyWorker.perform_async(Date.today)
      #   MyWorker.perform_async(DateTime.now)
      #   MyWorker.perform_async(ActiveSupport::TimeWithZone.new)
      #   MyWorker.perform_async(1.hour)
      #   MyWorker.perform_async(1.hour.ago)
      #
      #   # good
      #   MyWorker.perform_async(Time.now.to_i)
      #   MyWorker.perform_async(Date.today.to_s)
      #
      # @example AllowedMethods: [] (default)
      #   # bad
      #   MyWorker.perform_async(Time.now.mday)
      #
      # @example AllowedMethods: ['mday']
      #   # good
      #   MyWorker.perform_async(Time.now.mday)
      #
      class DateTimeArgument < ::RuboCop::Cop::Cop
        DURATION_METHODS = %i[
          second
          seconds
          minute
          minutes
          hour
          hours
          day
          days
          week
          weeks
          fortnight
          fortnights
        ].freeze

        DURATION_TO_TIME_METHODS = %i[
          from_now
          since
          after
          ago
          until
          before
        ].freeze

        include Helpers

        DURATION_MSG = 'Durations are not Sidekiq-serializable; use the integer instead.'
        MSG = 'Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.'
        ALLOWED_METHODS = %i[to_i to_s].freeze

        def_node_matcher :rational_literal?, <<~PATTERN
          (send
            (int _) :/
            (rational _))
        PATTERN

        def_node_matcher :duration?, <<~PATTERN
          {
            (send {int float rational #rational_literal?} #duration_method?)
            (send (const (const _ :ActiveSupport) :Duration) ...)
          }
        PATTERN

        def_node_matcher :date_time_send?, <<~PATTERN
          $(send
            `{
              (const _ {:Date :DateTime :Time})
              (const (const _ :ActiveSupport) :TimeWithZone)
            }
            ...
          )
        PATTERN

        def_node_matcher :date_time_arg?, <<~PATTERN
          { #duration? #date_time_send? (send `#duration? #duration_to_time_method?) }
        PATTERN

        def on_send(node)
          sidekiq_arguments(node).each do |arg|
            next unless date_time_arg?(arg)
            next if node_approved?(arg)

            # If the outer send (ie. the last method in the chain) is in the allowed method
            # list, approve the node (so that sub chains aren't flagged).
            if allowed_methods.include?(arg.method_name)
              approve_node(arg)
              next
            end

            add_offense(arg)
          end
        end

        def allowed_methods
          Array(cop_config['AllowedMethods']).concat(ALLOWED_METHODS).map(&:to_sym)
        end

        def duration_method?(sym)
          DURATION_METHODS.include?(sym)
        end

        def duration_to_time_method?(sym)
          DURATION_TO_TIME_METHODS.include?(sym)
        end

        def message(node)
          return DURATION_MSG if duration?(node)

          super
        end
      end
    end
  end
end
