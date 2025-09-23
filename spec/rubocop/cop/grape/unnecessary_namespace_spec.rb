# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Grape::UnnecessaryNamespace, :config do
  it 'registers an offense when using unnecessary namespace' do
    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        params do
          requires :id, type: Integer
        end

        desc 'Hello endpoint'
        delete do
          { hello: :world }.to_json
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        params do
          requires :id, type: Integer
        end

        desc 'Hello endpoint'
        get do
          { hello: :world }.to_json
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        params {}
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace 'a_space' do
      ^^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      resource :a_space do
      ^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      resources :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        get(root: false) {}
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        get do
          { hello: :world }.to_json
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
        params do
          requires :id, type: Integer
        end
        get do
          { hello: :world }.to_json
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
        namespace :b_space do
        ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
          params do
            requires :id, type: Integer
          end
          get do
            { hello: :world }.to_json
          end
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
        resources :b_space do
        ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
          params do
            requires :id, type: Integer
          end
          get do
            { hello: :world }.to_json
          end
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      resources :a_space do
        namespace :b_space do
        ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with an argument: `get :some_path`.
          params do
            requires :id, type: Integer
          end
          get do
            { hello: :world }.to_json
          end
        end
      end
    RUBY
  end

  it 'does not register an offense when namespace is require' do
    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        get {}
        patch {}
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        params do
          requires :id, type: Integer
        end
        get {}
        patch {}
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        params do
          requires :id, type: Integer
        end
        get do
          { hello: :world }.to_json
        end
        post {}
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        params do
          requires :id, type: Integer
        end
        get do
          { hello: :world }.to_json
        end
        route_param :id do
          put {}
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        params do
          requires :id, type: Integer
        end
        get do
          { hello: :world }.to_json
        end
        resources :b_space do
          put {}
          get {}
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        patch(:update) {}
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        patch('update') {}
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        get {}
        patch(:update) {}
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        get(root: false) {}
        patch(:update) {}
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :a_space do
        patch(:update, root: false) {}
      end
    RUBY
  end

  it 'does not register an offense when namespace contains Grape callbacks' do
    expect_no_offenses(<<~RUBY)
      namespace :my_namespace do
        after_validation do
          do_something
        end

        get do
          something
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :my_namespace do
        before do
          authenticate!
        end

        get do
          something
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :my_namespace do
        after do
          log_request
        end

        get do
          something
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :my_namespace do
        finally do
          cleanup
        end

        get do
          something
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :my_namespace do
        before_validation do
          normalize_params
        end

        get do
          something
        end
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      namespace :my_namespace do
        before do
          authenticate!
        end

        after_validation do
          do_something
        end

        get do
          something
        end
      end
    RUBY
  end
end
