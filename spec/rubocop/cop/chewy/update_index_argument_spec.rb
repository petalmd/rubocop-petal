# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Chewy::UpdateIndexArgument, :config do
  it 'registers an offense when using block with single expression' do
    expect_offense(<<~RUBY)
      update_index('index_name') { self }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use method symbol as second argument instead of block.
    RUBY

    expect_correction(<<~RUBY)
      update_index('index_name', :self)
    RUBY

    expect_offense(<<~RUBY)
      update_index('index_name', if: :update?) { self }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use method symbol as second argument instead of block.
    RUBY

    expect_correction(<<~RUBY)
      update_index('index_name', :self, if: :update?)
    RUBY

    expect_offense(<<~RUBY)
      update_index('index_name') { some_ids }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use method symbol as second argument instead of block.
    RUBY

    expect_correction(<<~RUBY)
      update_index('index_name', :some_ids)
    RUBY

    expect_offense(<<~RUBY)
      update_index('index_name', if: :update?) { some_ids }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use method symbol as second argument instead of block.
    RUBY

    expect_correction(<<~RUBY)
      update_index('index_name', :some_ids, if: :update?)
    RUBY
  end

  it 'does not register an offense when no block' do
    expect_no_offenses(<<~RUBY)
      update_index('index_name', :self)
    RUBY
  end

  it 'does not register an offense when the bock containe multiple expression' do
    expect_no_offenses(<<~RUBY)
      update_index('index_name') { something.call }
    RUBY

    expect_no_offenses(<<~RUBY)
      update_index('index_name') { something(id) }
    RUBY
  end
end
