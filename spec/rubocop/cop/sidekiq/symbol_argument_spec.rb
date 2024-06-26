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
