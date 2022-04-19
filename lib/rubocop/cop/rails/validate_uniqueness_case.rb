# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # Enforces to specify a case sensitive or case insensitive option
      # to the uniqueness validation.
      #
      # The default value in Rails 5 is `case_sensitive: true`. Which does not
      # reflect MySQL's default behavior. In Rails 6.1 the default value will be
      # `case_sensitive: false` to reflect MySQL's default behavior
      # (https://guides.rubyonrails.org/6_1_release_notes.html#active-record-notable-changes).
      #
      # # bad
      # validates :name, uniqueness: true
      # validates :name, uniqueness: { scope: :user_id }
      #
      # # good
      # validates :name, uniqueness: { case_sensitive: true }
      # validates :name, uniqueness: { scope: :user_id, case_sensitive: false }
      #
      class ValidateUniquenessCase < Base
        extend AutoCorrector

        MSG = 'Pass `case_sensitive: true|false` to uniqueness options.'
        RESTRICT_ON_SEND = %i[validates].freeze

        def_node_search :uniqueness?, <<~PATTERN
          (sym :uniqueness)
        PATTERN

        def_node_matcher :have_case_sensitive_options?, <<~PATTERN
          (pair (sym :case_sensitive) ${true false})
        PATTERN

        def on_send(node)
          uniqueness_options = match_uniqueness_options(node)
          return unless uniqueness_options

          uniqueness_child_options = uniqueness_options.children.last

          # When it's just `uniqueness: true`
          if uniqueness_child_options.boolean_type?
            boolean_uniqueness(uniqueness_options)
            return
          end

          case_sensitive_options = uniqueness_child_options.pairs.detect { |c| have_case_sensitive_options?(c) }

          return if case_sensitive_options

          hash_uniqueness(uniqueness_options)
        end

        def match_uniqueness_options(node)
          node.children.last.children.detect do |c|
            next if c.is_a?(Symbol)

            uniqueness?(c)
          end
        end

        def boolean_uniqueness(node)
          # When it's just `uniqueness: true`
          add_offense(node) do |corrector|
            corrector.replace(node, 'uniqueness: { case_sensitive: false }')
          end
        end

        def hash_uniqueness(node)
          add_offense(node) do |corrector|
            corrector.insert_after(node.loc.expression.adjust(end_pos: -2), ', case_sensitive: false')
          end
        end
      end
    end
  end
end
