# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::StubProducts, :config do
  context 'when using veil_product' do
    it 'registers an offense', :aggregate_failures do
      expect_offense(<<~RUBY)
        veil_product('MY_PRODUCT')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `stub_products` instead of veil/unveil_product.
      RUBY

      expect_correction(<<~RUBY)
        stub_products('MY_PRODUCT' => false)
      RUBY
    end
  end

  context 'when using unveil_product' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        unveil_product('MY_PRODUCT')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `stub_products` instead of veil/unveil_product.
      RUBY

      expect_correction(<<~RUBY)
        stub_products('MY_PRODUCT' => true)
      RUBY
    end
  end

  context 'when not using veil nor unveil_product' do
    it 'doesnt register an offense' do
      expect_no_offenses(<<~RUBY)
        stub_products('MY_PRODUCT' => group)
      RUBY
    end
  end
end
