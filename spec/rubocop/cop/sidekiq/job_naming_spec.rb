# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::JobNaming, :config do
  let(:config) { RuboCop::Config.new }

  context 'when class name ends with Worker and includes Sidekiq::Job' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class MyWorker
              ^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when class name ends with Worker and includes Sidekiq::Worker' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class ProcessDataWorker
              ^^^^^^^^^^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
          include Sidekiq::Worker
        end
      RUBY
    end
  end

  context 'when class name ends with Job and includes Sidekiq::Job' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class MyJob
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when class name ends with Job and includes Sidekiq::Worker' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class ProcessDataJob
          include Sidekiq::Worker
        end
      RUBY
    end
  end

  context 'when class does not include Sidekiq modules' do
    it 'does not register an offense even if name ends with Worker' do
      expect_no_offenses(<<~RUBY)
        class MyWorker
          include SomeOtherModule
        end
      RUBY
    end
  end

  context 'when class inherits from ApplicationWorker' do
    it 'registers an offense if name ends with Worker' do
      expect_offense(<<~RUBY)
        class EmailWorker < ApplicationWorker
              ^^^^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
        end
      RUBY
    end

    it 'does not register an offense if name ends with Job' do
      expect_no_offenses(<<~RUBY)
        class EmailJob < ApplicationWorker
        end
      RUBY
    end
  end

  context 'when using namespaced class names' do
    it 'registers an offense for Worker suffix' do
      expect_offense(<<~RUBY)
        class MyApp::EmailWorker
              ^^^^^^^^^^^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
          include Sidekiq::Job
        end
      RUBY
    end

    it 'does not register an offense for Job suffix' do
      expect_no_offenses(<<~RUBY)
        class MyApp::EmailJob
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when class name contains Worker but does not end with it' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class WorkerManager
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when using fully qualified Sidekiq modules' do
    it 'registers an offense for Worker suffix with ::Sidekiq::Job' do
      expect_offense(<<~RUBY)
        class MyWorker
              ^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
          include ::Sidekiq::Job
        end
      RUBY
    end

    it 'registers an offense for Worker suffix with ::Sidekiq::Worker' do
      expect_offense(<<~RUBY)
        class MyWorker
              ^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
          include ::Sidekiq::Worker
        end
      RUBY
    end
  end

  context 'when multiple classes are defined' do
    it 'registers offenses for all Worker-suffixed classes' do
      expect_offense(<<~RUBY)
        class FirstWorker
              ^^^^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
          include Sidekiq::Job
        end

        class SecondJob
          include Sidekiq::Job
        end

        class ThirdWorker
              ^^^^^^^^^^^ Sidekiq/JobNaming: Job class name should end with `Job` instead of `Worker`.
          include Sidekiq::Worker
        end
      RUBY
    end
  end
end
