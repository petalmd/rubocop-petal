# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::AuthenticatedAs, :config do
  it 'registers an offense when using `HTTP_API_KEY`' do
    expect_offense(<<~RUBY)
      get '/api/v2/my_endpoint', headers: { HTTP_API_KEY: user.api_key }
                                            ^^^^^^^^^^^^ Use `authenticated_as` instead of legacy api_key.
    RUBY

    expect_offense(<<~RUBY)
      get 'my_endpoint', headers: { HTTP_API_KEY: user.api_key }, params: { hello: :world }
                                    ^^^^^^^^^^^^ Use `authenticated_as` instead of legacy api_key.
    RUBY

    expect_offense(<<~RUBY)
      post 'my_endpoint', params: { hello: :world }, headers: { HTTP_API_KEY: user.api_key }, body: { hello: :world }
                                                                ^^^^^^^^^^^^ Use `authenticated_as` instead of legacy api_key.
    RUBY
  end

  it 'does not register an offense when not using `HTTP_API_KEY`' do
    expect_no_offenses(<<~RUBY)
      get 'my_endpoint'
    RUBY

    expect_no_offenses(<<~RUBY)
      get 'my_endpoint', params: { hello: :world }
    RUBY
  end
end
