# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::EnumStartingValue, :config do
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

  context 'when starts from zero' do
    context 'without prefix' do
      it 'expects an offense' do
        expect_offense(<<~RUBY)
          class MyModel
            enum my_enum: { state1: 0, state2: 2 }
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer starting from `1` instead of `0` with `enum`.
          end
        RUBY

        expect_offense(<<~RUBY)
          class MyModel
            enum my_enum: {
            ^^^^^^^^^^^^^^^ Prefer starting from `1` instead of `0` with `enum`.
              state1: 0,
              state2: 2
            }
          end
        RUBY

        expect_offense(<<~RUBY)
          class MyModel
            enum my_enum: { state1: 1, state2: 0 }
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer starting from `1` instead of `0` with `enum`.
          end
        RUBY
      end
    end

    context 'with prefix' do
      it 'expects an offense' do
        expect_offense(<<~RUBY)
          class MyModel
            enum my_enum: { state1: 0, state2: 2 }, _suffix: false
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer starting from `1` instead of `0` with `enum`.
          end
        RUBY

        expect_offense(<<~RUBY)
          class MyModel
            enum my_enum: {
            ^^^^^^^^^^^^^^^ Prefer starting from `1` instead of `0` with `enum`.
              state1: 0,
              state2: 2
            }, _prefix: true
          end
        RUBY
      end
    end
  end

  context 'when starts from a non zero' do
    it 'expects no offense' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          enum my_enum: { state1: 1, state2: 2 }, _prefix: true
        end
      RUBY

      expect_no_offenses(<<~RUBY)
        class MyModel
          enum my_enum: {
            state1: 2,
            state2: 3
          }
        end
      RUBY
    end
  end

  context 'when enum values are strings' do
    it 'expects no offense' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          enum my_enum: { default: 'default', console: 'console', scheduling: 'scheduling', booking: 'booking' }, _prefix: true
        end
      RUBY
    end
  end

  context 'when enum contains comments' do
    it 'expects no offense' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          enum action: {
                          state_one: 1, # related to state one
                          state_two: 2 # related to state two
                        }
        end
      RUBY
    end
  end

  context 'when enum values are defined in a constant' do
    before do
      stub_const('ENUM_VALUES', { state_one: 0, state_two: 1 }.freeze )
    end

    it 'expects no offense' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          enum action: ENUM_VALUES
        end
      RUBY
    end
  end
end
