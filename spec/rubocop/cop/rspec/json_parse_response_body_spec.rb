# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::JsonParseResponseBody, :config do
  it 'registers an offense when using `JSON.parse(response.body)`', :aggregate_failures do
    expect_offense(<<~RUBY)
      JSON.parse(response.body)
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `response.parsed_body` instead.
    RUBY

    expect_correction(<<~RUBY)
      response.parsed_body
    RUBY
  end
end
