# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::SymbolArgument, :config do
  let(:config) { RuboCop::Config.new }

  describe '#perform_async' do
    context 'when called with a symbol' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async('a', 1, :foo)
                                         ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
        RUBY

        expect_correction(<<~RUBY)
          MyWorker.perform_async('a', 1, "foo")
        RUBY
      end
    end

    context 'when called with an array' do
      context 'when array has no symbols' do
        it 'does not register an offense' do
          expect_no_offenses(<<~RUBY)
            MyWorker.perform_async('a', 1, ['foo'])
          RUBY
        end
      end

      context 'when array has a symbol' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, ['foo', :bar])
                                                   ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, ['foo', "bar"])
          RUBY
        end
      end

      context 'when array has a symbol percent literal' do
        context 'when symbol' do
          it 'registers an offense' do
            expect_offense(<<~RUBY)
              MyWorker.perform_async('a', 1, ['foo', %i(bar baz)])
                                                     ^^^^^^^^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
            RUBY
            expect_correction(<<~RUBY)
              MyWorker.perform_async('a', 1, ['foo', %w(bar baz)])
            RUBY
          end
        end

        context 'when string' do
          it 'does not register an offense' do
            expect_no_offenses(<<~RUBY)
              MyWorker.perform_async('a', 1, ['foo', %w(bar baz)])
            RUBY
          end
        end
      end

      context 'when array has an array of symbols' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, ['foo', [:bar]])
                                                    ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, ['foo', ["bar"]])
          RUBY
        end
      end

      context 'when array has a hash with symbols' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, ['foo', { bar: 'baz' }])
                                                     ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, ['foo', { "bar" => 'baz' }])
          RUBY
        end
      end
    end

    context 'when called with an percent literal' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async('a', 1, %i(foo bar))
                                         ^^^^^^^^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
        RUBY

        expect_correction(<<~RUBY)
          MyWorker.perform_async('a', 1, %w(foo bar))
        RUBY
      end
    end

    context 'when called with a hash' do
      context 'when key is a symbol' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, foo: 1)
                                           ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY

          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, "foo" => 1)
          RUBY
        end
      end

      context 'when value is a variable' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            a = 1
            MyWorker.perform_async('a', 1, bar: a)
                                           ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            a = 1
            MyWorker.perform_async('a', 1, "bar" => a)
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
            MyWorker.perform_async('a', 1, "bar" => 1.hour)
          RUBY
        end
      end

      context 'when value is a block type' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            my_service = MyService.new('a')
            MyWorker.perform_async('a', 1, bar: my_service.call('b'))
                                           ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            my_service = MyService.new('a')
            MyWorker.perform_async('a', 1, "bar" => my_service.call('b'))
          RUBY
        end
      end

      context 'when value is a boolean type' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, bar: true)
                                           ^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, "bar" => true)
          RUBY
        end
      end

      context 'when value is a symbol' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => :baz)
                                                    ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => "baz")
          RUBY
        end
      end

      context 'when value is a percent literal' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => %i(baz))
                                                    ^^^^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => %w(baz))
          RUBY
        end
      end

      context 'when value is a an array' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => [:baz])
                                                     ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, 'bar' => ["baz"])
          RUBY
        end
      end

      context 'when value is a another hash' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            MyWorker.perform_async('a', 1, 'foo' => { 'bar' => %i(baz) })
                                                               ^^^^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
          RUBY
          expect_correction(<<~RUBY)
            MyWorker.perform_async('a', 1, 'foo' => { 'bar' => %w(baz) })
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
            MyWorker.perform_async('a', 1, "bar" => "baz")
          RUBY
        end
      end
    end
  end

  describe '#perform_at' do
    context 'when called with a symbol' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, 'a', 1, :foo)
                                                     ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
        RUBY
        expect_correction(<<~RUBY)
          MyWorker.perform_at(Time.zone.now, 'a', 1, "foo")
        RUBY
      end
    end
  end

  describe '#perform_in' do
    context 'when called with a symbol' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_in(5.minutes, 'a', 1, :foo)
                                                 ^^^^ Sidekiq/SymbolArgument: Symbols are not Sidekiq-serializable; use strings instead.
        RUBY
        expect_correction(<<~RUBY)
          MyWorker.perform_in(5.minutes, 'a', 1, "foo")
        RUBY
      end
    end
  end
end
