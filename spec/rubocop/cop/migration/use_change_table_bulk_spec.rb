# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Migration::UseChangeTableBulk, :config do
  context 'without change_table' do
    it 'does not register an offense' do
      expect_no_offenses <<~RUBY
        class MyMigration < ActiveRecord::Migration[5.2]
          def up
            my_variable = :test
            some_function()
            MyClass.stuff()
          end
        end
      RUBY
    end
  end

  context 'with change_table' do
    context 'when using bulk: true' do
      it 'does not register an offense' do
        expect_no_offenses <<~RUBY
          class MyMigration < ActiveRecord::Migration[5.2]
            def up
              change_table :users, some_other_param: 'stuff', bulk: true, another_param: :some_sym do
                do_stuff()
              end
            end
          end
        RUBY
      end
    end

    context 'when using bulk: false' do
      it 'registers an offense' do
        expect_offense <<~RUBY
          class MyMigration < ActiveRecord::Migration[5.2]
            def up
              change_table :users, some_other_param: 'stuff', bulk: false, another_param: :some_sym do
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `change_table` with `bulk: true`.
                do_stuff()
              end
            end
          end
        RUBY
      end
    end

    context 'when bulk is omitted' do
      it 'registers an offense' do
        expect_offense <<~RUBY
          class MyMigration < ActiveRecord::Migration[5.2]
            def up
              change_table :users, some_other_param: 'stuff', another_param: :some_sym do
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `change_table` with `bulk: true`.
                do_stuff()
              end
            end
          end
        RUBY
      end
    end
  end
end
