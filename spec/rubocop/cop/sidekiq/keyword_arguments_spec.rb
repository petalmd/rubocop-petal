# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::KeywordArguments, :config do
  let(:config) { RuboCop::Config.new }

  describe 'when perform is defined with a keyword argument' do
    it 'registers an offense when using' do
      expect_offense(<<~RUBY)
        class WorkerClass
          include Sidekiq::Worker
        #{'  '}
          def perform(b:)
                      ^^ Sidekiq/KeywordArguments: Keyword arguments are not allowed in a sidekiq worker's perform method.
            do_something
          end
        end#{'                          '}
      RUBY
    end
  end

  describe 'when perform is not defined with a keyword' do
    it 'does not register an offense when using `#good_method`' do
      expect_no_offenses(<<~RUBY)
         class WorkerClass
          def perform(a, b='abc', **other)
            do_something
          end
        end
      RUBY
    end
  end
end
