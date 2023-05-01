# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::ModelAccessFromApiController, :config do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new(
      'Rails/ModelAccessFromApiController' => {
        'DisabledApis' => %w[
          fake_disabled_api
          FakeDisabledApiCamel
        ], 'DisabledControllers' => %w[
             fake_disabled_controller
             FakeDisabledControllerCamel
           ],
        'ApisPath' => 'app/api/',
        'ControllersPath' => 'app/controllers/',
        'ModelsPath' => 'app/models/',
        'AllowedModels' => ['WhitelistedModel']
      }
    )
  end

  let(:api_file) { '/root/app/api/file.rb' }

  before do
    allow(Dir).to(
      receive(:[])
        .with('app/models/**/*.rb')
        .and_return(%w[app/models/some_model.rb app/models/nested/global_model.rb])
    )
  end

  context 'with no violation' do
    describe 'when disabled api' do
      let(:disabled_api_file) do
        '/root/apis/fake_disabled_api/app/file.rb'
      end
      let(:source) do
        <<~RUBY
          SomeModel.find(123)
        RUBY
      end

      it 'does not add any offenses' do
        expect_no_offenses(source, disabled_api_file)
      end
    end

    describe 'disabled api camel case' do
      let(:disabled_api_file) do
        '/root/apis/fake_disabled_api_camel/app/file.rb'
      end
      let(:source) do
        <<~RUBY
          SomeModel.find(123)
        RUBY
      end

      it 'does not add any offenses' do
        expect_no_offenses(source, disabled_api_file)
      end
    end

    describe 'just accessing a const' do
      let(:source) do
        <<~RUBY
          a = SomeModel::SOME_CONST
        RUBY
      end

      it 'does not add any offenses' do
        expect_no_offenses(source, api_file)
      end
    end

    describe 'file in app/ outside api' do
      let(:non_api_file) { '/root/app/file.rb' }
      let(:source) do
        <<~RUBY
          SomeModel.find(123)
        RUBY
      end

      it 'does not add any offenses' do
        expect_no_offenses(source, non_api_file)
      end
    end

    describe 'with whitelisted model' do
      let(:source) do
        <<~RUBY
          WhitelistedModel.find(123)
        RUBY
      end

      it 'does not add any offenses' do
        expect_no_offenses(source, api_file)
      end
    end

    describe 'association to model in app/' do
      let(:non_api_file) { '/root/app/models/bar.rb' }
      let(:source) do
        <<~RUBY
          class Bar < ApplicationModel
            has_one :some_model, class_name: "SomeModel", inverse_of: :bar
          end
        RUBY
      end

      it 'does not add any offenses' do
        expect_no_offenses(source, non_api_file)
      end
    end

    describe 'association to other api model' do
      let(:source) do
        <<~RUBY
          class MyApi::Foo < ApplicationModel
            has_one :bar, class_name: "SomeOtherApi::Bar", inverse_of: :foo
          end
        RUBY
      end

      it 'does not add any offenses' do
        expect_no_offenses(source, api_file)
      end
    end
  end

  context 'with violation' do
    describe 'when access of model from api' do
      let(:source) do
        <<~RUBY
          SomeModel.new
          ^^^^^^^^^ Direct access of model from within Rails Api or Controller.
        RUBY
      end

      it 'adds an offense' do
        expect_offense(source, api_file)
      end
    end
  end

  describe '#external_dependency_checksum' do
    it 'differs based on contents of app/models dir' do
      old_checksum = cop.external_dependency_checksum
      allow(Dir).to(
        receive(:[])
          .with('app/models/**/*.rb')
          .and_return(['app/models/nested/model.rb'])
      )
      new_checksum = cop.external_dependency_checksum
      expect(new_checksum).not_to equal(old_checksum)
    end
  end
end
