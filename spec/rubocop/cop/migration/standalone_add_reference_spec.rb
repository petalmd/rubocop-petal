# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Migration::StandaloneAddReference, :config do
  it 'registers an offense when modifing a references outside a change_table' do
    expect_offense(<<~RUBY)
      add_reference :products, :user
      ^^^^^^^^^^^^^^ Modifying references must be done in a change_table block.
    RUBY

    expect_offense(<<~RUBY)
      add_reference :products, :user, index: true
      ^^^^^^^^^^^^^^ Modifying references must be done in a change_table block.
    RUBY

    expect_offense(<<~RUBY)
      belongs_to :products, :user
      ^^^^^^^^^^ Modifying references must be done in a change_table block.
    RUBY

    expect_offense(<<~RUBY)
      remove_reference :products, :user
      ^^^^^^^^^^^^^^^^^ Modifying references must be done in a change_table block.
    RUBY
  end

  it 'does not register an offense when not calling modifying references methods' do
    expect_no_offenses(<<~RUBY)
      add_index :users, :user_id
    RUBY
  end
end
