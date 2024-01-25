# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::DateTimeArgument, :config do
  let(:config) { RuboCop::Config.new }

  describe 'when perform_async is called with an ActiveSupport::TimeWithZone' do
    it 'registers an offense when using' do
      expect_offense(<<~RUBY)
        MyWorker.perform_async(Time.zone.now)
                               ^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
      RUBY
    end
  end

  describe 'when perform_async is called with a Date' do
    it 'registers an offense when using' do
      expect_offense(<<~RUBY)
        MyWorker.perform_async(Date.current)
                               ^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
      RUBY
    end
  end

  describe 'when perform_async is called with a Time' do
    it 'registers an offense when using' do
      expect_offense(<<~RUBY)
        MyWorker.perform_async(Time.now)
                               ^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
      RUBY
    end
  end

  describe 'when perform_async is called with a DateTime' do
    it 'registers an offense when using' do
      expect_offense(<<~RUBY)
        MyWorker.perform_async(DateTime.new(2001,2,3,4,5,6))
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/DateTimeArgument: Date/Time objects are not Sidekiq-serializable; convert to integers or strings instead.
      RUBY
    end
  end

  describe 'when perform_async is called with a ActiveSupport::Duration' do
    it 'registers an offense when using' do
      expect_offense(<<~RUBY)
        MyWorker.perform_async(1.hour)
                               ^^^^^^ Sidekiq/DateTimeArgument: Durations are not Sidekiq-serializable; use the integer instead.
      RUBY
    end
  end

  describe 'when perform_async is not date or time arguments' do
    it 'does not register an offense when using `#good_method`' do
      expect_no_offenses(<<~RUBY)
        MyWorker.perform_async(1, {'abc' => 3})
        do_something
      RUBY
    end
  end
end
