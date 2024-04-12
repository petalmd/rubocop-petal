# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::ConstArgument, :config do
  let(:config) { RuboCop::Config.new }

  describe '#perform_async' do
    context 'when a Const argument is present' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_async(1, {'abc' => 3}, MyClass, 1, {'abc' => 3})
                                                  ^^^^^^^ Sidekiq/ConstArgument: Objects are not Sidekiq-serializable.
        RUBY
      end
    end

    context 'when Const argument is not present' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          MyWorker.perform_async(1, {'abc' => 3})                                   
        RUBY
      end
    end
  end

  describe '#perform_at' do
    context 'when a Const argument is present' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          at = Time.zone.now.iso8601
          MyWorker.perform_at(at, 1, {'abc' => 3}, MyClass, 1, {'abc' => 3})
                                                   ^^^^^^^ Sidekiq/ConstArgument: Objects are not Sidekiq-serializable.
        RUBY
      end
    end

    context 'when Const argument is not present' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          at = Time.zone.now.to_s
          MyWorker.perform_at(at, 1, {'abc' => 3})                                   
        RUBY
      end
    end
  end

  describe '#perform_in' do
    context 'when a Const argument is present' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          MyWorker.perform_in(5.seconds, 1, {'abc' => 3}, MyClass, 1, {'abc' => 3})
                                                          ^^^^^^^ Sidekiq/ConstArgument: Objects are not Sidekiq-serializable.
        RUBY
      end
    end

    context 'when Const argument is not present' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          MyWorker.perform_in(5.seconds, 1, {'abc' => 3})                                   
        RUBY
      end
    end
  end
end
