# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sidekiq::KeywordArguments, :config do
  let(:config) { RuboCop::Config.new }

  describe 'Basic declaration' do
    it 'registers an offense' do
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

  describe 'Anonymous class' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Class.new do
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

  describe 'ApplicationWorker' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class WorkerClass < ApplicationWorker

        #{'  '}
          def perform(b:)
                      ^^ Sidekiq/KeywordArguments: Keyword arguments are not allowed in a sidekiq worker's perform method.
            do_something
          end
        end#{'                          '}
      RUBY
    end
  end

  describe 'Anonymous class with ApplicationWorker' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
          Class.new(ApplicationWorker) do
            #{'  '}
            def perform(b:)
                        ^^ Sidekiq/KeywordArguments: Keyword arguments are not allowed in a sidekiq worker's perform method.
              do_something
            end
          end#{'                          '}
      RUBY
    end
  end
end
