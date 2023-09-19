# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # Cop to enforce the use of `find_each(&:destroy!)` over `destroy_all`.
      # https://docs.rubocop.org/rubocop-rails/cops_rails.html#railssavebang
      # https://github.com/rails/rails/pull/37782
      # https://discuss.rubyonrails.org/t/proposal-add-destroy-all-method-to-activerecord-relation/80959
      #
      #   # bad
      #   User.destroy_all
      #
      #   # good
      #   User.find_each(&:destroy!)
      class DestroyAllBang < Base
        extend AutoCorrector
        MSG = 'Use `find_each(&:destroy!)` instead of `destroy_all`.'
        RESTRICT_ON_SEND = %i[destroy_all].freeze

        def on_send(node)
          destroy_all_range = node.loc.selector
          add_offense(destroy_all_range) do |corrector|
            corrector.replace(node.loc.selector, 'find_each(&:destroy!)')
          end
        end
      end
    end
  end
end
