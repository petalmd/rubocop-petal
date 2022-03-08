# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Migration::SchemaStatementsMethods, :config do
  it 'registers an offense when using ActiveRecord connection' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.connection.table_exists? 'users'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use already defined methods. Remove `ActiveRecord::Base.connection`.

      ActiveRecord::Base.connection.column_exists? 'users', :first_name
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use already defined methods. Remove `ActiveRecord::Base.connection`.

      ApplicationRecord.connection.table_exists? 'SELECT COUNT(*) FROM `users`'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use already defined methods. Remove `ActiveRecord::Base.connection`.
    RUBY
  end

  it 'autocorrects' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.connection.table_exists? 'users'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use already defined methods. Remove `ActiveRecord::Base.connection`.
    RUBY

    expect_correction(<<~RUBY)
      table_exists? 'users'
    RUBY
  end

  it 'does not register an offense when using defined methods' do
    expect_no_offenses(<<~RUBY)
      table_exists? 'users'

      column_exists? 'users', :first_name

      execute 'SELECT COUNT(*) FROM `users`'
    RUBY
  end
end
