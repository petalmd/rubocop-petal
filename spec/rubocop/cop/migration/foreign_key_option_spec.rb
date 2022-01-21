# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Migration::ForeignKeyOption, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when not specifying the foreign key option' do
    expect_offense(<<~RUBY)
      add_references :products, :user
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add `foreign_key: true` or `foreign_key: { to_table: :some_table }`

      add_belongs_to :products, :user
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add `foreign_key: true` or `foreign_key: { to_table: :some_table }`

      t.references :user
      ^^^^^^^^^^^^^^^^^^ Add `foreign_key: true` or `foreign_key: { to_table: :some_table }`

      t.belongs_to :user
      ^^^^^^^^^^^^^^^^^^ Add `foreign_key: true` or `foreign_key: { to_table: :some_table }`
    RUBY
  end

  it 'does not register an offense when setting foreign_key option to create constrant' do
    expect_no_offenses(<<~RUBY)
      add_references :products, :user, foreign_key: true

      add_belongs_to :products, :user, foreign_key: true

      t.references :user, foreign_key: true

      t.belongs_to :user, foreign_key: true

      add_references :products, :user, foreign_key: { to_table: :users }

      add_references :products, :user, polymorphic: true

      t.references :user, polymorphic: true
    RUBY
  end
end
