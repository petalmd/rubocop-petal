# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Migration::ChangeTableReferences, :config do
  it 'registers an offense when using references in a change_table' do
    expect_offense(<<~RUBY)
      change_table :subscriptions, bulk: true do |t|
         t.string :name
         t.string :email
         t.boolean :admin, default: false
         t.references :user, null: false, foreign_key: true
         ^^^^^^^^^^^^ Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table to add a reference.Or `t.remove_foreign_key`, `t.remove` to remove a reference.
      end
    RUBY

    expect_offense(<<~RUBY)
      change_table :subscriptions, bulk: true do |t|
         t.string :name
         t.belongs_to :user, null: false, foreign_key: true
         ^^^^^^^^^^^^ Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table to add a reference.Or `t.remove_foreign_key`, `t.remove` to remove a reference.
         t.boolean :admin, default: false
      end
    RUBY

    expect_offense(<<~RUBY)
      change_table :subscriptions, bulk: true do |t|
         t.remove_references :user, null: false, foreign_key: true
         ^^^^^^^^^^^^^^^^^^^ Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table to add a reference.Or `t.remove_foreign_key`, `t.remove` to remove a reference.
      end
    RUBY

    expect_offense(<<~RUBY)
      change_table :subscriptions, bulk: true do |t|
         t.remove_belongs_to :user, null: false, foreign_key: true
         ^^^^^^^^^^^^^^^^^^^ Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table to add a reference.Or `t.remove_foreign_key`, `t.remove` to remove a reference.
      end
    RUBY

    # With multiple layer of blocks
    expect_offense(<<~RUBY)
      foo do
        change_table :subscriptions, bulk: true do |t|
           t.belongs_to :user, null: false, foreign_key: true
           ^^^^^^^^^^^^ Use a combination of `t.bigint`, `t.index` and `t.foreign_key` in a change_table to add a reference.Or `t.remove_foreign_key`, `t.remove` to remove a reference.
        end
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
