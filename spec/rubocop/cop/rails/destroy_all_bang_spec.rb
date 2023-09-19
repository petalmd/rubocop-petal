# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::DestroyAllBang, :config do
  it 'registers an offense when using `destroy_all`' do
    expect_offense(<<~RUBY)
      User.destroy_all
           ^^^^^^^^^^^ Use `find_each(&:destroy!)` instead of `destroy_all`.
    RUBY

    expect_correction(<<~RUBY)
      User.find_each(&:destroy!)
    RUBY

    expect_offense(<<~RUBY)
      User.where(desactivated: true).destroy_all
                                     ^^^^^^^^^^^ Use `find_each(&:destroy!)` instead of `destroy_all`.
    RUBY

    expect_correction(<<~RUBY)
      User.where(desactivated: true).find_each(&:destroy!)
    RUBY

    expect_offense(<<~RUBY)
      User
        .where(desactivated: true)
        .destroy_all
         ^^^^^^^^^^^ Use `find_each(&:destroy!)` instead of `destroy_all`.
    RUBY

    expect_correction(<<~RUBY)
      User
        .where(desactivated: true)
        .find_each(&:destroy!)
    RUBY
  end

  it 'does not register an offense when using `#each(&:destroy!)`' do
    expect_no_offenses(<<~RUBY)
      User.find_each(&:destroy!)
    RUBY

    expect_no_offenses(<<~RUBY)
      User.each(&:destroy!)
    RUBY
  end
end
