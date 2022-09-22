# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::SidekiqInline, :config do
  it 'registers an offense when using `Sidekiq::Testing.inline!`' do
    expect_offense(<<~RUBY)
      Sidekiq::Testing.inline! { }
      ^^^^^^^^^^^^^^^^^^^^^^^^ Stub `perform_async` and call inline worker with `new.perform`.
    RUBY
  end
end
