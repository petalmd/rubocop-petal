# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::JobLocation, :config do
  let(:config) { RuboCop::Config.new }

  context 'when Job class is in app/workers directory' do
    it 'registers an offense for Job suffix with Sidekiq::Job' do
      expect_offense(<<~RUBY, 'app/workers/my_job.rb')
        class MyJob
              ^^^^^ Sidekiq/JobLocation: Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.
          include Sidekiq::Job
        end
      RUBY
    end

    it 'registers an offense for Job suffix with Sidekiq::Worker' do
      expect_offense(<<~RUBY, 'app/workers/process_data_job.rb')
        class ProcessDataJob
              ^^^^^^^^^^^^^^ Sidekiq/JobLocation: Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.
          include Sidekiq::Worker
        end
      RUBY
    end

    it 'registers an offense for namespaced Job class' do
      expect_offense(<<~RUBY, 'app/workers/my_app/email_job.rb')
        class MyApp::EmailJob
              ^^^^^^^^^^^^^^^ Sidekiq/JobLocation: Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.
          include Sidekiq::Job
        end
      RUBY
    end

    it 'registers an offense for Job class inheriting from ApplicationWorker' do
      expect_offense(<<~RUBY, 'app/workers/notification_job.rb')
        class NotificationJob < ApplicationWorker
              ^^^^^^^^^^^^^^^ Sidekiq/JobLocation: Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.
        end
      RUBY
    end

    it 'does not register an offense for Worker suffix' do
      expect_no_offenses(<<~RUBY, 'app/workers/my_worker.rb')
        class MyWorker
          include Sidekiq::Job
        end
      RUBY
    end

    it 'does not register an offense for non-Sidekiq Job class' do
      expect_no_offenses(<<~RUBY, 'app/workers/my_job.rb')
        class MyJob
          include SomeOtherModule
        end
      RUBY
    end
  end

  context 'when Job class is in app/jobs directory' do
    it 'does not register an offense for Job suffix with Sidekiq::Job' do
      expect_no_offenses(<<~RUBY, 'app/jobs/my_job.rb')
        class MyJob
          include Sidekiq::Job
        end
      RUBY
    end

    it 'does not register an offense for Job suffix with Sidekiq::Worker' do
      expect_no_offenses(<<~RUBY, 'app/jobs/process_data_job.rb')
        class ProcessDataJob
          include Sidekiq::Worker
        end
      RUBY
    end

    it 'does not register an offense for namespaced Job class' do
      expect_no_offenses(<<~RUBY, 'app/jobs/my_app/email_job.rb')
        class MyApp::EmailJob
          include Sidekiq::Job
        end
      RUBY
    end

    it 'does not register an offense for Job class inheriting from ApplicationWorker' do
      expect_no_offenses(<<~RUBY, 'app/jobs/notification_job.rb')
        class NotificationJob < ApplicationWorker
        end
      RUBY
    end
  end

  context 'when Job class is in other directories' do
    it 'does not register an offense for lib directory' do
      expect_no_offenses(<<~RUBY, 'lib/my_job.rb')
        class MyJob
          include Sidekiq::Job
        end
      RUBY
    end

    it 'does not register an offense for spec directory' do
      expect_no_offenses(<<~RUBY, 'spec/jobs/my_job_spec.rb')
        class MyJobSpec
          include Sidekiq::Job
        end
      RUBY
    end

    it 'does not register an offense for root directory' do
      expect_no_offenses(<<~RUBY, 'my_job.rb')
        class MyJob
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when class name contains Job but does not end with it' do
    it 'does not register an offense in app/workers' do
      expect_no_offenses(<<~RUBY, 'app/workers/job_manager.rb')
        class JobManager
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when using fully qualified Sidekiq modules' do
    it 'registers an offense for Job suffix with ::Sidekiq::Job in app/workers' do
      expect_offense(<<~RUBY, 'app/workers/my_job.rb')
        class MyJob
              ^^^^^ Sidekiq/JobLocation: Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.
          include ::Sidekiq::Job
        end
      RUBY
    end

    it 'does not register an offense for Job suffix with ::Sidekiq::Job in app/jobs' do
      expect_no_offenses(<<~RUBY, 'app/jobs/my_job.rb')
        class MyJob
          include ::Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when multiple classes are defined' do
    it 'registers offenses for all Job-suffixed classes in app/workers' do
      expect_offense(<<~RUBY, 'app/workers/multiple_jobs.rb')
        class FirstJob
              ^^^^^^^^ Sidekiq/JobLocation: Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.
          include Sidekiq::Job
        end

        class SecondWorker
          include Sidekiq::Job
        end

        class ThirdJob
              ^^^^^^^^ Sidekiq/JobLocation: Job class with `Job` suffix should be placed in `app/jobs` directory instead of `app/workers`.
          include Sidekiq::Worker
        end
      RUBY
    end
  end
end
