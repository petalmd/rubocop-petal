# frozen_string_literal: true

module RuboCop
  module Cop
    module Performance
      # Prevent using `snif`.
      # Consider using `detect`.
      #
      # @example
      #   # bad
      #   period.equity_packs.snif(:code, 'ONCALL')
      #
      #   # good
      #   period.equity_packs.detect { |equity_pack| equity_pack.code == 'ONCALL' }
      class Snif < Base
        MSG = 'Use `detect` instead.'

        def_node_matcher :snif?, <<~PATTERN
          (send _ :snif _ _)
        PATTERN

        def on_send(node)
          return unless snif?(node)

          add_offense(node)
        end
      end
    end
  end
end
