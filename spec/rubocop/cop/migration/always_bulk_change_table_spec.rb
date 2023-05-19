# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Migration::AlwaysBulkChangeTable, :config do
  it 'registers an offense when not using bulk: true' do
    expect_offense(<<~RUBY)
      change_table :users do |t|
      ^^^^^^^^^^^^^^^^^^^ Add `bulk: true` when using change_table.
         t.string :name
      end
    RUBY

    expect_offense(<<~RUBY)
      change_table :users, bulk: false do |t|
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add `bulk: true` when using change_table.
         t.string :name
      end
    RUBY
  end

  it 'does not register an offense when using change_table and bulk true' do
    expect_no_offenses(<<~RUBY)
      change_table :users, bulk: true do |t|
         t.string :name
      end
    RUBY
  end
end
