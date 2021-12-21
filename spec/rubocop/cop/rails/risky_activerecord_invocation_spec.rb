# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::RiskyActiverecordInvocation do
  subject(:cop) { described_class.new }

  it "allows where statement that's a hash" do
    source = [
      'Users.where({:name => "Bob"})'
    ].join("\n")

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "allows where statement that's a flat string" do
    source = 'Users.where("age = 24")'

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows a multiline where statement' do
    source = "Users.where(\"age = 24 OR \" \\\n\"age = 25\")"

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'allows interpolation in subsequent arguments to where' do
    source = 'Users.where("name like ?", "%#{name}%")' # rubocop:disable Lint/InterpolationCheck, Style/FormatStringToken

    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it 'disallows interpolation in where statements' do
    source = 'Users.where("name = #{username}")' # rubocop:disable Lint/InterpolationCheck

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'disallows addition in where statements' do
    source = 'Users.where("name = " + username)'

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end

  it 'disallows interpolation in order statements' do
    source = 'Users.where("age = 24").order("name #{sortorder}")' # rubocop:disable Lint/InterpolationCheck

    inspect_source(source)
    expect(cop.offenses.size).to eq(1)
  end
end
