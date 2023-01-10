# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::JsonResponse, :config do
  it 'registers an offense when using `json_response`', :aggregate_failures do
    expect_offense(<<~RUBY)
      json_response
      ^^^^^^^^^^^^^ Use `response.parsed_body` instead.
    RUBY

    expect_correction(<<~RUBY)
      response.parsed_body
    RUBY
  end
end
