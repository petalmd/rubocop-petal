# frozen_string_literal: true

require 'rubocop-rspec'

RSpec.describe RuboCop::Cop::RSpec::MultipleExpectations, :config do
  let(:cop_config) do
    # rubocop_rspec_default_config = RuboCop::ConfigLoader.default_configuration['RSpec']['MultipleExpectations']
    gem_dir = Gem::Specification.find_by_name("rubocop-rspec").gem_dir
    RuboCop::ConfigLoader.configuration_file_for(gem_dir)
  end

  it 'autocorrects multiple expectations with aggregate_failures' do
    expect_offense(<<-RUBY)
        describe Foo do
          it 'uses expect twice' do
          ^^^^^^^^^^^^^^^^^^^^^^ Example has too many expectations [2/1].
            expect(foo).to eq(bar)
            expect(baz).to eq(bar)
          end
        end
      RUBY

    # expect_correction(<<~RUBY)
    #   it do
    #     expect(foo).to eq(1)
    #     expect(foo).to eq(2)
    #   end
    # RUBY
  end
end
