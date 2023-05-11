# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::SidekiqInline, :config do
  it 'registers an offense when using `Sidekiq::Testing.inline!`' do
    expect_offense(<<~RUBY)
      Sidekiq::Testing.inline! { }
      ^^^^^^^^^^^^^^^^^^^^^^^^ Use `MyWorker.drain` method instead of `Sidekiq::Testing.inline!`.
    RUBY
  end
end
