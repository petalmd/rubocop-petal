# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Migration::ChangeTableReferences, :config do
  it 'registers an offense when using references in a change_table' do
    expect_offense(<<~RUBY)
      change_table :subscriptions, bulk: true do |t|
         t.references :user, null: false, foreign_key: true
         ^^^^^^^^^^^^ Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table.
      end
    RUBY

    expect_offense(<<~RUBY)
      change_table :subscriptions, bulk: true do |t|
         t.belongs_to :user, null: false, foreign_key: true
         ^^^^^^^^^^^^ Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table.
      end
    RUBY
  end

  it 'does not register an offense when using references in a create_table' do
    expect_no_offenses(<<~RUBY)
      create_table :subscriptions do |t|
         t.belongs_to :user, null: false, foreign_key: true
      end
    RUBY
  end

  it 'does not register an offense when not using references in a create_table' do
    expect_no_offenses(<<~RUBY)
      change_table :subscriptions do |t|
         t.index :user_id
      end
    RUBY
  end
end
