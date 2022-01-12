# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::CreateListMax, :config do
  let(:cop_config) { RuboCop::Config.new('Max' => 2) }

  it 'registers an offense when creating more than Max' do
    expect_offense(<<~RUBY)
      create_list :my_model, 100
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Creating more than `2` records is discouraged.
    RUBY

    expect_offense(<<~RUBY)
      my_records = create_list :my_model, 100
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^ Creating more than `2` records is discouraged.
    RUBY

    expect_offense(<<~RUBY)
      FactoryBot.create_list :my_model, 100, name: 'Hello'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Creating more than `2` records is discouraged.
    RUBY

    expect_offense(<<~RUBY)
      FactoryBot.create_list(:my_model, 100, name: 'Hello')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Creating more than `2` records is discouraged.
    RUBY

    expect_offense(<<~RUBY)
      create_list :my_model, 100, name: 'Hello' do |my_record|
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Creating more than `2` records is discouraged.
      end
    RUBY

    expect_offense(<<~RUBY)
      let(:my_record) { FactoryBot.create(:my_parent, children: FactoryBot.create_list(:my_model, 3)) }
                                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Creating more than `2` records is discouraged.
    RUBY
  end

  it 'does not register an offense when using less than Max' do
    expect_no_offenses(<<~RUBY)
      create_list :my_model, 2, name: 'Hello'
    RUBY

    expect_no_offenses(<<~RUBY)
      build_list :my_model, 100, name: 'Hello'
    RUBY
  end
end
