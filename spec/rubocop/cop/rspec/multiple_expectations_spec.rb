# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::MultipleExpectations, :config do
  it 'autocorrects multiple expectations with aggregate_failures' do
    expect_offense(<<~RUBY)
      describe Foo do
        it 'uses expect twice' do
        ^^^^^^^^^^^^^^^^^^^^^^ Example has too many expectations [2/1].
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      describe Foo do
        it 'uses expect twice', :aggregate_failures do
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      describe Foo do
        it do
        ^^ Example has too many expectations [2/1].
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      describe Foo do
        it :aggregate_failures do
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      describe Foo do
        it('uses expect twice') do
        ^^^^^^^^^^^^^^^^^^^^^^^ Example has too many expectations [2/1].
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      describe Foo do
        it('uses expect twice', :aggregate_failures) do
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      describe Foo do
        it 'uses expect twice', timecop: true do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Example has too many expectations [2/1].
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      describe Foo do
        it 'uses expect twice', :aggregate_failures, timecop: true do
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      describe Foo do
        it('uses expect twice', timecop: true) do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Example has too many expectations [2/1].
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      describe Foo do
        it('uses expect twice', :aggregate_failures, timecop: true) do
          expect(foo).to eq(bar)
          expect(baz).to eq(bar)
        end
      end
    RUBY
  end
end
