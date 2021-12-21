# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Grape::HelpersIncludeModule, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `helpers` with a block to include a module' do
    expect_offense(<<~RUBY)
      helpers do
        include MyModule
        ^^^^^^^^^^^^^^^^ Use `helpers MyModule` instead of `helpers` with a block.
      end
    RUBY

    expect_offense(<<~RUBY)
      helpers do
        include MyModule
        ^^^^^^^^^^^^^^^^ Use `helpers MyModule` instead of `helpers` with a block.
        include MyOtherModule
        ^^^^^^^^^^^^^^^^^^^^^ Use `helpers MyOtherModule` instead of `helpers` with a block.
      end
    RUBY
  end

  it 'does not register an offense when using `helpers` without a block to include module' do
    expect_no_offenses(<<~RUBY)
      helpers MyModule
    RUBY

    expect_no_offenses(<<~RUBY)
      helpers MyModule, MyOtherModule
    RUBY

    expect_no_offenses(<<~RUBY)
      helpers do
        def my_helper_method; end
      end
    RUBY
  end
end
