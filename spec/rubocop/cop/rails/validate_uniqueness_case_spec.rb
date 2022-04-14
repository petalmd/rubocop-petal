# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::ValidateUniquenessCase do
  let(:cop_class) { described_class }
  let(:cop) { cop_class.new }

  it 'registers an offense when not setting case_sensitive' do
    expect_offense(<<~RUBY)
      validates :first_name, uniqueness: true
                             ^^^^^^^^^^^^^^^^ Pass `case_sensitive: true|false` to uniqueness options.
    RUBY

    expect_correction(<<~RUBY)
      validates :first_name, uniqueness: { case_sensitive: false }
    RUBY

    expect_offense(<<~RUBY)
      validates :first_name, uniqueness: { scope: :last_name }
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Pass `case_sensitive: true|false` to uniqueness options.
    RUBY

    expect_correction(<<~RUBY)
      validates :first_name, uniqueness: { scope: :last_name, case_sensitive: false }
    RUBY

    expect_offense(<<~RUBY)
      validates :first_name, :email, uniqueness: { scope: :last_name }
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Pass `case_sensitive: true|false` to uniqueness options.
    RUBY

    expect_correction(<<~RUBY)
      validates :first_name, :email, uniqueness: { scope: :last_name, case_sensitive: false }
    RUBY
  end

  it 'does not register an offense when using case_sensitive' do
    expect_no_offenses(<<~RUBY)
      validates :first_name, uniqueness: { case_sensitive: true }
    RUBY

    expect_no_offenses(<<~RUBY)
      validates :first_name, uniqueness: { scope: :last_name, case_sensitive: true }
    RUBY

    expect_no_offenses(<<~RUBY)
      validates :first_name, uniqueness: { case_sensitive: true, scope: :last_name }
    RUBY

    expect_no_offenses(<<~RUBY)
      validates :first_name, uniqueness: { case_sensitive: false, scope: :last_name }
    RUBY

    expect_no_offenses(<<~RUBY)
      validates :first_name, :last_name
    RUBY
  end
end
