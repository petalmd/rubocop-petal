# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::AggregateFailuresTag, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using :aggregate_failures on describe' do
    expect_offense(<<~RUBY)
      describe '#enabled?', :aggregate_failures do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'registers an offense when using :aggregate_failures on context' do
    expect_offense(<<~RUBY)
      context 'when enabled', :aggregate_failures do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'registers an offense when using :aggregate_failures on feature' do
    expect_offense(<<~RUBY)
      feature 'user login', :aggregate_failures do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        scenario 'successful login' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'registers an offense when using :aggregate_failures on example_group' do
    expect_offense(<<~RUBY)
      example_group 'testing', :aggregate_failures do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        it 'works' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'registers an offense when using :aggregate_failures on xdescribe' do
    expect_offense(<<~RUBY)
      xdescribe '#enabled?', :aggregate_failures do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'registers an offense when using :aggregate_failures on fdescribe' do
    expect_offense(<<~RUBY)
      fdescribe '#enabled?', :aggregate_failures do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'registers an offense when :aggregate_failures is in a hash argument on describe' do
    expect_offense(<<~RUBY)
      describe '#enabled?', aggregate_failures: true do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'registers an offense when :aggregate_failures is mixed with other tags on describe' do
    expect_offense(<<~RUBY)
      describe '#enabled?', :slow, :aggregate_failures, :integration do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ RSpec/AggregateFailuresTag: The `:aggregate_failures` tag should only be used on examples, not on example groups.
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures on it' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        it 'returns true', :aggregate_failures do
          expect(true).to be true
          expect(false).to be false
        end
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures on specify' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        specify 'the behavior', :aggregate_failures do
          expect(true).to be true
          expect(false).to be false
        end
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures on example' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        example 'the behavior', :aggregate_failures do
          expect(true).to be true
          expect(false).to be false
        end
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures on scenario' do
    expect_no_offenses(<<~RUBY)
      feature 'user login' do
        scenario 'successful login', :aggregate_failures do
          expect(true).to be true
          expect(false).to be false
        end
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures on its' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        its(:enabled?, :aggregate_failures) { is_expected.to be true }
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures in hash on it' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        it 'returns true', aggregate_failures: true do
          expect(true).to be true
          expect(false).to be false
        end
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures on focused examples' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        fit 'returns true', :aggregate_failures do
          expect(true).to be true
          expect(false).to be false
        end
      end
    RUBY
  end

  it 'does not register an offense when using :aggregate_failures on skipped examples' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        xit 'returns true', :aggregate_failures do
          expect(true).to be true
          expect(false).to be false
        end
      end
    RUBY
  end

  it 'does not register an offense when using other tags on describe' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?', :slow, :integration do
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end

  it 'does not register an offense when describe has no tags' do
    expect_no_offenses(<<~RUBY)
      describe '#enabled?' do
        it 'returns true' do
          expect(true).to be true
        end
      end
    RUBY
  end
end
