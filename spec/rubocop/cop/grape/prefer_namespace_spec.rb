# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Grape::PreferNamespace, :config do
  context 'when using an alias' do
    context 'when using `group`' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          group :my_group do
          ^^^^^^^^^^^^^^^ Prefer using `namespace` over its aliases.
            get {}
          end
        RUBY

        expect_correction(<<~RUBY)
          namespace :my_group do
            get {}
          end
        RUBY
      end
    end

    context 'when using `resource`' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          resource :my_resource do
          ^^^^^^^^^^^^^^^^^^^^^ Prefer using `namespace` over its aliases.
            get {}
          end
        RUBY

        expect_correction(<<~RUBY)
          namespace :my_resource do
            get {}
          end
        RUBY
      end
    end

    context 'when using `resources`' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          resources :my_resources do
          ^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `namespace` over its aliases.
            get {}
          end
        RUBY

        expect_correction(<<~RUBY)
          namespace :my_resources do
            get {}
          end
        RUBY
      end
    end

    context 'when using `segment`' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          segment :my_segment do
          ^^^^^^^^^^^^^^^^^^^ Prefer using `namespace` over its aliases.
            get {}
          end
        RUBY

        expect_correction(<<~RUBY)
          namespace :my_segment do
            get {}
          end
        RUBY
      end
    end

    context 'when there are multiple parameters' do
      it 'corrects without breaking the params' do
        expect_offense(<<~RUBY)
          segment :my_segment, 'some other param' do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `namespace` over its aliases.
            get {}
          end
        RUBY

        expect_correction(<<~RUBY)
          namespace :my_segment, 'some other param' do
            get {}
          end
        RUBY
      end
    end

    context 'when the namespace is passed as a string' do
      it 'corrects without breaking the params' do
        expect_offense(<<~RUBY)
          segment 'some_str', 'some other param' do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `namespace` over its aliases.
            get {}
          end
        RUBY

        expect_correction(<<~RUBY)
          namespace 'some_str', 'some other param' do
            get {}
          end
        RUBY
      end
    end
  end

  it 'does not register an offense when using namespace' do
    expect_no_offenses(<<~RUBY)
      namespace :my_group do
        get {}
      end
    RUBY
  end

  it 'does not register an offense when a method with a similar name' do
    expect_no_offenses(<<~RUBY)
      namespace :my_group do
        get do
          SomeClass.group(:stuff, :together)
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :my_group do
        get do
          group = my_initializer()
          group.my_super_method()
          transform_this(group)
        end
      end
    RUBY
  end
end
