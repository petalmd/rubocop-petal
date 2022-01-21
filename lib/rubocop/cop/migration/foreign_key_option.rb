# frozen_string_literal: true

module RuboCop
  module Cop
    module Migration
      # Specify the foreign key option to create the constraint.
      #
      #   # bad
      #   add_reference(:products, :user)
      #   add_reference(:products, :user, foreign_key: false)
      #   add_belongs_to(:products, :user)
      #   t.references(:user)
      #
      #   # good
      #   add_reference(:products, :user, foreign_key: true)
      #   add_reference(:products, :user, foreign_key: { to_table: users })
      #   add_belongs_to(:products, :user, foreign_key: true)
      #   t.references(:user, foreign_key: true)
      #
      class ForeignKeyOption < Base
        MSG = 'Add `foreign_key: true` or `foreign_key: { to_table: :some_table }`'

        ADDING_REFERENCES_METHODS = Set.new(%i[add_references add_belongs_to references belongs_to]).freeze

        def_node_matcher :adding_references?, <<~PATTERN
          (send _ ADDING_REFERENCES_METHODS ...)
        PATTERN

        def_node_matcher :foreign_key_option?, <<~PATTERN
          (send _ ADDING_REFERENCES_METHODS ... (hash <(pair (sym :foreign_key) {true hash}) ...>))
        PATTERN

        def_node_matcher :polymorphic_references?, <<~PATTERN
          (... (hash <(pair (sym :polymorphic) true) ... >))
        PATTERN

        def on_send(node)
          return unless adding_references?(node)
          return if polymorphic_references?(node)

          add_offense(node) unless foreign_key_option?(node)
        end
      end
    end
  end
end
