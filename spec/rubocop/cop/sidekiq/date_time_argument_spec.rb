# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::DateTimeArgument, :config do
  let(:config) { RuboCop::Config.new }

  describe '#perform_async' do
    context 'when called with an ActiveSupport::TimeWithZone' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async(Time.zone.now)
                                 ^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end

      it 'registers an offense on Time.current' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async(Time.current)
                                 ^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    context 'when called with a Date' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async(Date.current)
                                 ^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a Time' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async(Time.now)
                                 ^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a DateTime' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async(DateTime.new(2001,2,3,4,5,6))
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a ActiveSupport::Duration' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async(1.hour)
                                 ^^^^^^ Sidekiq/DateTimeArgument: Durations are not Sidekiq-serializable; use the integer instead.
        RUBY
      end
    end
  end

  describe '#perform_at' do
    context 'when called with an ActiveSupport::TimeWithZone' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, Time.zone.now)
                                             ^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    context 'when called with a Date' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, Date.current)
                                             ^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a Time' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, Time.now)
                                             ^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a DateTime' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, DateTime.new(2001,2,3,4,5,6))
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a ActiveSupport::Duration' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, 1.hour)
                                             ^^^^^^ Sidekiq/DateTimeArgument: Durations are not Sidekiq-serializable; use the integer instead.
        RUBY
      end
    end
  end

  describe '#perform_in' do
    context 'when called with an ActiveSupport::TimeWithZone' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_in(5.minutes, Time.zone.now)
                                         ^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    context 'when called with a Date' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_in(5.minutes, Date.current)
                                         ^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a Time' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_in(5.minutes, Time.now)
                                         ^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a DateTime' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_in(5.minutes, DateTime.new(2001,2,3,4,5,6))
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
        RUBY
      end
    end

    describe 'when called with a ActiveSupport::Duration' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(5.minutes, 1.hour)
                                         ^^^^^^ Sidekiq/DateTimeArgument: Durations are not Sidekiq-serializable; use the integer instead.
        RUBY
      end
    end
  end
end
