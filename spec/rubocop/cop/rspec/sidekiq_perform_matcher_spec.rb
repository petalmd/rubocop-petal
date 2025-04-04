# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::SidekiqPerformMatcher, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using perform_async' do
    expect_offense(<<~RUBY)
      expect(MyWorker).to receive(:perform_async)
                          ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/SidekiqPerformMatcher: Use `have_enqueued_sidekiq_job` instead of `receive(:perform_async)`.
    RUBY
  end

  it 'registers an offense when using perform_async with parameters' do
    expect_offense(<<~RUBY)
      expect(MyWorker).to receive(:perform_async).with('arg1', 'arg2')
                          ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/SidekiqPerformMatcher: Use `have_enqueued_sidekiq_job` instead of `receive(:perform_async)`.
    RUBY
  end

  it 'registers an offense when using perform_in' do
    expect_offense(<<~RUBY)
      expect(MyWorker).to receive(:perform_in)
                          ^^^^^^^^^^^^^^^^^^^^ RSpec/SidekiqPerformMatcher: Use `have_enqueued_sidekiq_job` instead of `receive(:perform_in)`.
    RUBY
  end

  it 'registers an offense when using perform_in with time and arguments' do
    expect_offense(<<~RUBY)
      expect(MyWorker).to receive(:perform_in).with(5.minutes, user.id)
                          ^^^^^^^^^^^^^^^^^^^^ RSpec/SidekiqPerformMatcher: Use `have_enqueued_sidekiq_job` instead of `receive(:perform_in)`.
    RUBY
  end

  it 'registers an offense when using perform_at' do
    expect_offense(<<~RUBY)
      expect(MyWorker).to receive(:perform_at)
                          ^^^^^^^^^^^^^^^^^^^^ RSpec/SidekiqPerformMatcher: Use `have_enqueued_sidekiq_job` instead of `receive(:perform_at)`.
    RUBY
  end

  it 'registers an offense with chained expectations' do
    expect_offense(<<~RUBY)
      expect(MyWorker).to receive(:perform_async).once
                          ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/SidekiqPerformMatcher: Use `have_enqueued_sidekiq_job` instead of `receive(:perform_async)`.
    RUBY
  end

  it 'registers an offense when using perform_bulk' do
    expect_offense(<<~RUBY)
      expect(MyWorker).to receive(:perform_bulk)
                          ^^^^^^^^^^^^^^^^^^^^^^ RSpec/SidekiqPerformMatcher: Use `have_enqueued_sidekiq_job` instead of `receive(:perform_bulk)`.
    RUBY
  end

  it 'does not register an offense when using have_enqueued_sidekiq_job' do
    expect_no_offenses(<<~RUBY)
      expect(MyWorker).to have_enqueued_sidekiq_job('arg1', 'arg2')
    RUBY
  end

  it 'does not register an offense for unrelated matchers' do
    expect_no_offenses(<<~RUBY)
      expect(MyWorker).to receive(:some_other_method)
    RUBY
  end
end
