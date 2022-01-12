# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Grape::UnnecessaryNamespace, :config do
  it 'registers an offense when using unnecessary namespace' do
    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
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
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
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
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
        params {}
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace 'a_space' do
      ^^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      resource :a_space do
      ^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      resources :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
        get {}
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
        get do
          { hello: :world }.to_json
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      namespace :a_space do
      ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
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
        ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
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
        ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
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
        ^^^^^^^^^^^^^^^^^^ Unnecessary usage of Grape namespace. Specify endpoint name with a argument: `get :my_namespace`.
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
  end
end
