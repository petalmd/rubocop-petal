# frozen_string_literal: true

require 'active_support/inflector'
require 'digest/sha1'

module RuboCop
  module Cop
    module Rails
      # This cop checks for API or Controllers classes reaching directly into app/ models.
      #
      # Inspired by:
      # https://flexport.engineering/isolating-rails-engines-with-rubocop-210feaba3164
      # https://github.com/flexport/rubocop-flexport/pull/5/files
      #
      # With an Model/ActiveRecord object, Api or Controller code can perform arbitrary
      # reads and arbitrary writes to models located in the main `app/`
      # directory. This cop helps isolate Rails Api code to ensure
      # that modular boundaries are respected.
      #
      # Checks for both access via `MyModel.foo` and associations.
      #
      # @example
      #
      #   # bad
      #
      #   class MyApi::MyService
      #     m = SomeModel.find(123)
      #     m.any_random_attribute = "whatever i want"
      #     m.save
      #   end
      #
      #   # good
      #
      #   class MyApi::MyService
      #     ApiServiceForModels.perform_a_supported_operation("foo")
      #   end
      #
      # @example
      #
      #   # bad
      #
      #   class MyApi::MyModel < ApplicationModel
      #     has_one :some_model, class_name: "SomeModel"
      #   end
      #
      #   # good
      #
      #   class MyApi::MyModel < ApplicationModel
      #     # No direct association to global models.
      #   end
      #
      class ModelAccessFromApiController < Base
        MSG = 'Direct access of model from within Rails Api or Controller.'

        def_node_matcher :rails_association_hash_args, <<-PATTERN
          (send _ {:belongs_to :has_one :has_many} sym $hash)
        PATTERN

        def on_const(node)
          return unless in_enforced_api_file? || in_enforced_controller_file?
          return unless global_model_const?(node)
          # The cop allows access to e.g. MyGlobalModel::MY_CONST.
          return if child_of_const?(node)

          add_offense(node)
        end

        def on_send(node)
          return unless in_enforced_api_file? || in_enforced_controller_file?

          rails_association_hash_args(node) do |assocation_hash_args|
            class_name_node = extract_class_name_node(assocation_hash_args)
            class_name = class_name_node&.value
            next unless global_model?(class_name)

            add_offense(class_name_node)
          end
        end

        # Because this cop's behavior depends on the state of external files,
        # we override this method to bust the RuboCop cache when those files
        # change.
        def external_dependency_checksum
          Digest::SHA1.hexdigest(model_dir_paths.join)
        end

        private

        def global_model_names
          @global_model_names ||= calculate_global_models
        end

        def model_dir_paths
          Dir[File.join(global_models_path, '**/*.rb')]
        end

        def calculate_global_models
          all_model_paths = model_dir_paths.reject do |path|
            path.include?('/concerns/')
          end
          all_models = all_model_paths.map do |path|
            # Translates `app/models/foo/bar_baz.rb` to `Foo::BarBaz`.
            file_name = path.gsub(global_models_path, '').gsub('.rb', '')
            ActiveSupport::Inflector.classify(file_name)
          end
          all_models - allowed_global_models
        end

        def extract_class_name_node(assocation_hash_args)
          assocation_hash_args.each_pair do |key, value|
            return value if key.value == :class_name && value.str_type?
          end
          nil
        end

        def in_enforced_api_file?
          file_path = processed_source.path
          return false unless file_path.include?(apis_or_controllers_path('api'))
          return false if in_disabled_api?(file_path)

          true
        end

        def in_enforced_controller_file?
          file_path = processed_source.path
          return false unless file_path.include?(apis_or_controllers_path('controller'))
          return false if in_disabled_controller?(file_path)

          true
        end

        def in_disabled_api?(file_path)
          disabled_apis.any? do |e|
            file_path.include?(File.join(apis_or_controllers_path('api'), e))
          end
        end

        def in_disabled_controller?(file_path)
          disabled_controllers.any? do |e|
            file_path.include?(File.join(apis_or_controllers_path('controller'), e))
          end
        end

        def global_model_const?(const_node)
          # Remove leading `::`, if any.
          class_name = const_node.source.sub(/^:*/, '')
          global_model?(class_name)
        end

        # class_name is e.g. "FooGlobalModelNamespace::BarModel"
        def global_model?(class_name)
          global_model_names.include?(class_name)
        end

        def child_of_const?(node)
          node.parent.const_type?
        end

        def global_models_path
          path = cop_config['ModelsPath']
          path += '/' unless path.end_with?('/')
          path
        end

        def apis_or_controllers_path(which_one)
          which_one == 'api' ? cop_config['ApisPath'] : cop_config['ControllersPath']
        end

        def disabled_apis
          raw = cop_config['DisabledApis'] || []
          raw.map do |e|
            ActiveSupport::Inflector.underscore(e)
          end
        end

        def disabled_controllers
          raw = cop_config['DisabledControllers'] || []
          raw.map do |e|
            ActiveSupport::Inflector.underscore(e)
          end
        end

        def allowed_global_models
          cop_config['AllowedModels'] || []
        end
      end
    end
  end
end
