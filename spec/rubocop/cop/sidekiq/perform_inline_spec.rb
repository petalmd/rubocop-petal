# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::PerformInline, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `new.perform`' do
    expect_offense(<<~RUBY)
      MyWorker.new.perform
               ^^^^^^^^^^^ Sidekiq/PerformInline: Use `perform_inline` instead of `new.perform`
    RUBY

    expect_correction(<<~RUBY)
      MyWorker.perform_inline
    RUBY

    expect_offense(<<~RUBY)
      MyWorker.new.perform(123, 'abc')
               ^^^^^^^^^^^ Sidekiq/PerformInline: Use `perform_inline` instead of `new.perform`
    RUBY

    expect_correction(<<~RUBY)
      MyWorker.perform_inline(123, 'abc')
    RUBY

    expect_offense(<<~RUBY)
      MyWorker
        .new
      ^^^^^^ Sidekiq/PerformInline: Use `perform_inline` instead of `new.perform`
        .perform(123, 'abc')
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      MyWorker.perform_inline
    RUBY
  end
end
