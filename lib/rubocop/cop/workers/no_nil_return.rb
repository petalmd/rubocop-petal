# frozen_string_literal: true
require 'byebug'
module RuboCop
  module Cop
    module Workers
      # Ensure workers avoid returning early
      #
      # # bad
      # def perform
      #   return if condition
      #   ...
      # end
      #
      # # good
      # def perform
      #   # TDB, idea would be `raise SilentError if condition`
      # end

      class NoNilReturn < Base
        MSG = 'Avoid using early nil return in workers.'

        def on_return(node)
          add_offense(node) if node.arguments.first&.nil_type? || node.arguments.empty?
        end
      end
    end
  end
end
