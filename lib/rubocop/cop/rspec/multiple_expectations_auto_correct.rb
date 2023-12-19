# frozen_string_literal: true

require 'rubocop-rspec'

module RuboCop
  module Cop
    module RSpec
      module MultipleExpectationsAutoCorrect
        private

        def flag_example(node, expectation_count:)
          add_offense(
            node.send_node,
            message: format(
              RuboCop::Cop::RSpec::MultipleExpectations::MSG,
              total: expectation_count,
              max: max_expectations
            )
          ) do |corrector|
            autocorrect(node, corrector)
          end
        end

        def autocorrect(node, corrector)
          if (args = node.children.first.arguments.first)
            corrector.insert_after(args, ', :aggregate_failures')
          else
            corrector.insert_after(node.children.first, ' :aggregate_failures')
          end
        end
      end
    end
  end
end

RuboCop::Cop::RSpec::MultipleExpectations
  .extend(RuboCop::Cop::AutoCorrector)
RuboCop::Cop::RSpec::MultipleExpectations
  .prepend(RuboCop::Cop::RSpec::MultipleExpectationsAutoCorrect)
