# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ownership::Team, :config do
  let(:ownership_file_path) { 'config/ownership.yml' }
  let(:cop_config) { RuboCop::Config.new('OwnershipFilePath' => ownership_file_path) }

  before do
    allow(cop).to receive(:read_ownership_file).with(ownership_file_path).and_return(<<~YAML)
      my_team:
        products:
          - my_product
          - my_other_product
    YAML
  end

  it 'registers an offense when using a team not registered in the file' do
    expect_offense(<<~RUBY)
      ownership :my_random_team
                ^^^^^^^^^^^^^^^ Team not registered in the OwnershipFile. (config/ownership.yml)
    RUBY

    expect_offense(<<~RUBY)
      ownership :my_random_team, products: [:my_product]
                ^^^^^^^^^^^^^^^ Team not registered in the OwnershipFile. (config/ownership.yml)
    RUBY

    expect_offense(<<~RUBY)
      ownership :my_random_team, products: [:my_product], criticality: :low
                ^^^^^^^^^^^^^^^ Team not registered in the OwnershipFile. (config/ownership.yml)
    RUBY
  end

  it 'does not register an offense when using a team registered in the file' do
    expect_no_offenses(<<~RUBY)
      ownership :my_team
    RUBY

    expect_no_offenses(<<~RUBY)
      ownership :my_team, products: [:my_product]
    RUBY

    expect_no_offenses(<<~RUBY)
      ownership :my_team, products: [:my_product], criticality: :low
    RUBY
  end
end
