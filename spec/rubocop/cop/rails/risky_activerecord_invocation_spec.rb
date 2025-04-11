# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::RiskyActiverecordInvocation do
  subject(:cop) { described_class.new }

  it "allows where statement that's a hash" do
    expect_no_offenses('Users.where({:name => "Bob"})')
  end

  it "allows where statement that's a flat string" do
    expect_no_offenses('Users.where("age = 24")')
  end

  it 'allows a multiline where statement' do
    expect_no_offenses(<<~RUBY)
      Users.where("age = 24 OR " \\
      "age = 25")
    RUBY
  end

  it 'allows interpolation in subsequent arguments to where' do
    expect_no_offenses('Users.where("name like ?", "%#{name}%")')
  end

  it 'disallows interpolation in where statements' do
    expect_offense(<<~RUBY)
      Users.where("name = \#{username}") # rubocop:disable Lint/InterpolationCheck
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Rails/RiskyActiverecordInvocation: Passing a string computed by interpolation or addition to an ActiveRecord method is likely to lead to SQL injection. Use hash or parameterized syntax. For more information, see http://guides.rubyonrails.org/security.html#sql-injection-countermeasures and https://rails-sqli.org/rails3. If you have confirmed with Security that this is a safe usage of this style, disable this alert with `# rubocop:disable Rails/RiskyActiverecordInvocation`.
    RUBY
  end

  it 'disallows addition in where statements' do
    expect_offense(<<~RUBY)
      Users.where("name = " + username)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Rails/RiskyActiverecordInvocation: Passing a string computed by interpolation or addition to an ActiveRecord method is likely to lead to SQL injection. Use hash or parameterized syntax. For more information, see http://guides.rubyonrails.org/security.html#sql-injection-countermeasures and https://rails-sqli.org/rails3. If you have confirmed with Security that this is a safe usage of this style, disable this alert with `# rubocop:disable Rails/RiskyActiverecordInvocation`.
    RUBY
  end

  it 'disallows interpolation in order statements' do
    expect_offense(<<~RUBY)
      Users.where("age = 24").order("name \#{sortorder}") # rubocop:disable Lint/InterpolationCheck
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Rails/RiskyActiverecordInvocation: Passing a string computed by interpolation or addition to an ActiveRecord method is likely to lead to SQL injection. Use hash or parameterized syntax. For more information, see http://guides.rubyonrails.org/security.html#sql-injection-countermeasures and https://rails-sqli.org/rails3. If you have confirmed with Security that this is a safe usage of this style, disable this alert with `# rubocop:disable Rails/RiskyActiverecordInvocation`.
    RUBY
  end
end
