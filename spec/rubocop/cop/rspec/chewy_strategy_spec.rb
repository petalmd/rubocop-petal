# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::ChewyStrategy, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using Chewy.strategy' do
    expect_offense(<<~RUBY)
      let(:user) { Chewy.strategy(:atomic) { create(:user) } }
                   ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/ChewyStrategy: Do not use Chewy.strategy in tests. Import data explicitly instead.
    RUBY
  end

  it 'registers an offense for multiline Chewy.strategy usage' do
    expect_offense(<<~RUBY)
      let(:user) do
        Chewy.strategy(:urgent) do
        ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/ChewyStrategy: Do not use Chewy.strategy in tests. Import data explicitly instead.
          create(:user)
        end
      end
    RUBY
  end
  
  it 'registers an offense when assigning Chewy.strategy to a variable' do
    expect_offense(<<~RUBY)
      before do
        result = Chewy.strategy(:bypass) { create(:user) }
                 ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/ChewyStrategy: Do not use Chewy.strategy in tests. Import data explicitly instead.
      end
    RUBY
  end

  it 'registers an offense when using Chewy.strategy in a before block' do
    expect_offense(<<~RUBY)
      before do
        Chewy.strategy(:zero) { User.create!(name: 'Test') }
        ^^^^^^^^^^^^^^^^^^^^^ RSpec/ChewyStrategy: Do not use Chewy.strategy in tests. Import data explicitly instead.
      end
    RUBY
  end

  it 'registers an offense for different strategy types' do
    expect_offense(<<~RUBY)
      it 'creates a user' do
        Chewy.strategy(:bypass) { create(:user) }
        ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/ChewyStrategy: Do not use Chewy.strategy in tests. Import data explicitly instead.
      end
    RUBY
  end

  it 'registers an offense when using Chewy.strategy in a helper method' do
    expect_offense(<<~RUBY)
      def create_user
        Chewy.strategy(:urgent) { create(:user) }
        ^^^^^^^^^^^^^^^^^^^^^^^ RSpec/ChewyStrategy: Do not use Chewy.strategy in tests. Import data explicitly instead.
      end
    RUBY
  end
end
