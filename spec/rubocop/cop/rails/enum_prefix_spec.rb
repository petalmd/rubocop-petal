# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::EnumPrefix do
  let(:cop_class) { described_class }
  let(:cop) { cop_class.new }

  context 'without an enum' do
    it 'expects no offense' do
      expect_no_offenses(<<~RUBY)
        puts 'some stuff'

        # Declares a model without enum
        class MyModel
          has_many :some_other_thing
        end
      RUBY
    end
  end

  context 'with an enum without a prefix or suffix' do
    it 'expects an offense' do
      expect_offense(<<~RUBY)
        class MyModel
          enum my_enum: {state1: 1, state2: 2}
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using a `_prefix` or `_suffix` with `enum`.
        end
      RUBY

      expect_offense(<<~RUBY)
        class MyModel
          enum my_enum: {
          ^^^^^^^^^^^^^^^ Prefer using a `_prefix` or `_suffix` with `enum`.
            state1: 1,
            state2: 2
          }
        end
      RUBY
    end
  end

  context 'when using a prefix' do
    context 'when it is a boolean' do
      it 'expects no offense' do
        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {state1: 1, state2: 2}, _prefix: true
          end
        RUBY

        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {
              state1: 1,
              state2: 2
            }, _prefix: true
          end
        RUBY
      end
    end

    context 'when it is a string' do
      it 'expects no offense' do
        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {state1: 1, state2: 2}, _prefix: 'some_prefix'
          end
        RUBY

        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {
              state1: 1,
              state2: 2
            }, _prefix: 'some_prefix'
          end
        RUBY
      end
    end

    context 'when it is a symbol' do
      it 'expects no offense' do
        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {state1: 1, state2: 2}, _prefix: :some_prefix
          end
        RUBY

        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {
              state1: 1,
              state2: 2
            }, _prefix: :some_prefix
          end
        RUBY
      end
    end
  end

  context 'when using a suffix' do
    context 'when it is a boolean' do
      it 'expects no offense' do
        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {state1: 1, state2: 2}, _suffix: true
          end
        RUBY

        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {
              state1: 1,
              state2: 2
            }, _suffix: true
          end
        RUBY
      end
    end

    context 'when it is a string' do
      it 'expects no offense' do
        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {state1: 1, state2: 2}, _suffix: 'some_suffix'
          end
        RUBY

        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {
              state1: 1,
              state2: 2
            }, _suffix: 'some_suffix'
          end
        RUBY
      end
    end

    context 'when it is a symbol' do
      it 'expects no offense' do
        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {state1: 1, state2: 2}, _suffix: :some_suffix
          end
        RUBY

        expect_no_offenses(<<~RUBY)
          class MyModel
            enum my_enum: {
              state1: 1,
              state2: 2
            }, _suffix: :some_suffix
          end
        RUBY
      end
    end
  end
end
