# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::PreferJob, :config do
  let(:config) { RuboCop::Config.new }

  context 'when using Sidekiq::Worker' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class MyWorker
          include Sidekiq::Worker
          ^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/PreferJob: Prefer `Sidekiq::Job` over `Sidekiq::Worker`.
        end
      RUBY

      expect_correction(<<~RUBY)
        class MyWorker
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when using Sidekiq::Job' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class MyJob
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when including other modules' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class MyClass
          include SomeOtherModule
        end
      RUBY
    end
  end

  context 'when including Sidekiq::Worker in multiple classes' do
    it 'registers offenses for all occurrences' do
      expect_offense(<<~RUBY)
        class FirstWorker
          include Sidekiq::Worker
          ^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/PreferJob: Prefer `Sidekiq::Job` over `Sidekiq::Worker`.
        end

        class SecondWorker
          include Sidekiq::Worker
          ^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/PreferJob: Prefer `Sidekiq::Job` over `Sidekiq::Worker`.
        end
      RUBY

      expect_correction(<<~RUBY)
        class FirstWorker
          include Sidekiq::Job
        end

        class SecondWorker
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when using fully qualified Sidekiq::Worker' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class MyWorker
          include ::Sidekiq::Worker
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/PreferJob: Prefer `Sidekiq::Job` over `Sidekiq::Worker`.
        end
      RUBY

      expect_correction(<<~RUBY)
        class MyWorker
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when including Sidekiq::Worker with other modules' do
    it 'registers an offense only for Sidekiq::Worker' do
      expect_offense(<<~RUBY)
        class MyWorker
          include SomeOtherModule
          include Sidekiq::Worker
          ^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/PreferJob: Prefer `Sidekiq::Job` over `Sidekiq::Worker`.
          include AnotherModule
        end
      RUBY

      expect_correction(<<~RUBY)
        class MyWorker
          include SomeOtherModule
          include Sidekiq::Job
          include AnotherModule
        end
      RUBY
    end
  end

  context 'when using Sidekiq::Worker in a module' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        module MyModule
          include Sidekiq::Worker
          ^^^^^^^^^^^^^^^^^^^^^^^ Sidekiq/PreferJob: Prefer `Sidekiq::Job` over `Sidekiq::Worker`.
        end
      RUBY

      expect_correction(<<~RUBY)
        module MyModule
          include Sidekiq::Job
        end
      RUBY
    end
  end

  context 'when using similar but different module names' do
    it 'does not register an offense for Sidekiq::WorkerExtension' do
      expect_no_offenses(<<~RUBY)
        class MyWorker
          include Sidekiq::WorkerExtension
        end
      RUBY
    end

    it 'does not register an offense for MySidekiq::Worker' do
      expect_no_offenses(<<~RUBY)
        class MyWorker
          include MySidekiq::Worker
        end
      RUBY
    end
  end
end
