# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Chewy::FieldType, :config do
  it 'registers an offense when no iting a field' do
    expect_offense(<<~RUBY)
      field :name
      ^^^^^^^^^^^ Specify a `type` for Chewy field.
    RUBY

    expect_offense(<<~RUBY)
      field :name, value: 'text'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Specify a `type` for Chewy field.
    RUBY

    expect_offense(<<~RUBY)
      field :name, value: lambda { |a| a.name.upcase }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Specify a `type` for Chewy field.
    RUBY

    expect_offense(<<~RUBY)
      defined_type User do
        field :name
        ^^^^^^^^^^^ Specify a `type` for Chewy field.
      end
    RUBY

    expect_offense(<<~RUBY)
      field :name, :email
      ^^^^^^^^^^^^^^^^^^^ Specify a `type` for Chewy field.
    RUBY
  end

  it 'does not register an offense when a type is specified' do
    expect_no_offenses(<<~RUBY)
      field :name, type: 'text'
    RUBY

    expect_no_offenses(<<~RUBY)
      field :name, type: :text
    RUBY

    expect_no_offenses(<<~RUBY)
      field :name, :email, type: 'text'
    RUBY
  end
end
