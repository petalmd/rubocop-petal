# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::JsonParseResponseBody, :config do
  it 'registers an offense when using `JSON.parse(response.body)`' do
    expect_offense(<<~RUBY)
      JSON.parse(response.body)
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `response.parsed_body` instead.
    RUBY
  end
end
