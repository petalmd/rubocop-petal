# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::SymbolArgument, :config do
  let(:config) { RuboCop::Config.new }

  describe '#perform_async' do
    describe 'when called with a symbol' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async('a', 1, :foo)
                                         ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
        RUBY

        expect_correction(<<~RUBY)
          MyWorker.perform_async('a', 1, 'foo')
        RUBY
      end
    end

    context 'when argument is a Hash' do
      context 'when key is a symbol' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, foo: 1)
                                           ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY

          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, 'foo' => 1)
          RUBY
        end

        context 'when value is a var' do
          it 'registers an offense' do
            expect_offense(<<~RUBY)
              a = 1
              MyWorker.perform_async('a', 1, bar: a)
                                             ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
            RUBY
            expect_correction(<<~RUBY)
              a = 1
              MyWorker.perform_async('a', 1, 'bar' => a)
            RUBY
          end
        end

        context 'when value is a function' do
          it 'registers an offense' do
            expect_offense(<<~RUBY)
              MyWorker.perform_async('a', 1, bar: 1.hour)
                                             ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
            RUBY
            expect_correction(<<~RUBY)
              MyWorker.perform_async('a', 1, 'bar' => 1.hour)
            RUBY
          end
        end
      end

      context 'when value is a symbol' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => :baz)
                                                    ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
        end
      end

      context 'when key/value are symbols' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, bar: :baz)
                                           ^^^^^^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => 'baz')
          RUBY
        end
      end
    end
  end

  describe '#perform_at' do
    describe 'when called with a symbol' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, 'a', 1, :foo)
                                                     ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
        RUBY
      end
    end
  end

  describe '#perform_in' do
    describe 'when called with a symbol' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_in(5.minutes, 'a', 1, :foo)
                                                 ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
        RUBY
      end
    end
  end
end
