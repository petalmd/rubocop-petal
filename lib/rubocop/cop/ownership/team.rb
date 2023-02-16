# frozen_string_literal: true

module RuboCop
  module Cop
    module Ownership
      # Check if the ownership definition respect the definition in the
      # OwnershipFile for the of teams.
      #
      # An OwnershipFile is a YAML file with the following structure:
      #   my_team:
      #    products:
      #     - my_product
      #     - my_other_product
      #   my_other_team:
      #    products:
      #     - my_product
      #     - my_awesome_product
      #
      # @example OwnershipFilePath: config/ownership.yml
      #   # The path of the OwnershipFile.
      #
      class Team < Base
        RESTRICT_ON_SEND = %i[ownership].freeze

        MSG = 'Team not registered in the OwnershipFile.'

        def on_send(node)
          init_config!

          team_argument = node.children[2].value.to_s
          return if teams.include?(team_argument)

          add_offense(node.children[2], message: MSG + " (#{ownership_file_path})")
        end

        private

        def init_config!
          @@config ||= # rubocop:disable Style/ClassVars
            begin
              file_path_from_config = ownership_file_path
              raise 'OwnershipFile is not set' unless file_path_from_config

              YAML.safe_load(read_ownership_file(file_path_from_config))
            end
        end

        def teams
          @teams ||= @@config.keys
        end

        def ownership_file_path
          cop_config['OwnershipFilePath']
        end

        def read_ownership_file(file_path)
          File.read(file_path)
        end
      end
    end
  end
end
