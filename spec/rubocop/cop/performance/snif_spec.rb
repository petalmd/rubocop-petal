# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::Snif, :config do
  it 'registers an offense when using `snif`', :aggregate_failures do
    expect_offense(<<~RUBY)
      test.snif(:attribute, value)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `detect` instead.
    RUBY

    expect_offense(<<~RUBY)
      test.snif(attribute, value)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `detect` instead.
    RUBY
  end
end
