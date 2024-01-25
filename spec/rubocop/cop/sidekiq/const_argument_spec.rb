# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::ConstArgument, :config do
  let(:config) { RuboCop::Config.new }

  describe 'when perform_async is called with an Const' do
    it 'registers an offense when using' do
      expect_offense(<<~RUBY)
        MyWorker.perform_async(MyClass)
                               ^^^^^^^ Sidekiq/ConstArgument: Objects are not Sidekiq-serializable.
      RUBY
    end
  end

  describe 'when perform_async is not a Const' do
    it 'does not register an offense when using `#good_method`' do
      expect_no_offenses(<<~RUBY)
        MyWorker.perform_async(1, {'abc' => 3})
        do_something
      RUBY
    end
  end
end
