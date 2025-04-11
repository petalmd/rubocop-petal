# frozen_string_literal: true

require 'lint_roller'

module RuboCop
  module Petal
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-petal',
          version: VERSION,
          homepage: 'https://github.com/petalmd/rubocop-petal',
          description: 'Petal global cops configuration'
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join('../../../config/default.yml')
        )
      end
    end
  end
end
