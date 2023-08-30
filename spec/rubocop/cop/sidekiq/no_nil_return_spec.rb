# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::NoNilReturn, :config do
  subject(:cop) { described_class.new }

  describe 'when analizing worker code' do
    context 'with an early nil return with unless' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class WorkerClass
            def perform
              unless some_condition
                return
                ^^^^^^ Sidekiq/NoNilReturn: Avoid using early nil return in workers.
              end
              do_something
            end
          end
        RUBY
      end
    end

    context 'with an early nil return with if' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class WorkerClass
            def perform
              if some_condition
                return
                ^^^^^^ Sidekiq/NoNilReturn: Avoid using early nil return in workers.
              end
              do_something
            end
          end
        RUBY
      end
    end

    context 'with an inline early nil return with unless' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class WorkerClass
            def perform
              return unless some_condition
              ^^^^^^ Sidekiq/NoNilReturn: Avoid using early nil return in workers.
              do_something
            end
          end
        RUBY
      end
    end

    context 'with an inline early nil return with if' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class WorkerClass
            def perform
              return if some_condition
              ^^^^^^ Sidekiq/NoNilReturn: Avoid using early nil return in workers.
              do_something
            end
          end
        RUBY
      end
    end

    context 'with a return in a ternary' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class WorkerClass
            def perform
              some_condition ? return : do_something
                               ^^^^^^ Sidekiq/NoNilReturn: Avoid using early nil return in workers.
              do_something_else
            end
          end
        RUBY
      end
    end

    context 'when returning a non-nil value' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          class WorkerClass
            def perform
              return false if some_condition
              do_something
            end
          end
        RUBY
      end
    end
  end
end
