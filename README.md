# RuboCop::Petal

[![Build](https://github.com/petalmd/rubocop-petal/actions/workflows/build.yml/badge.svg)](https://github.com/petalmd/rubocop-petal/actions/workflows/build.yml)

Petal custom cops. List of cops can be find [here](https://github.com/petalmd/rubocop-petal/tree/main/lib/rubocop/cop).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-petal', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rubocop-petal

## Usage

In your `.rubocop.yml` file, add `rubocop-petal`

```yaml
require:
  - rubocop-rails
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Create new cop

```shell
bundle exec rake 'new_cop[Rails/MyNewCop]'
```

## Release

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petalmd/rubocop-petal.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
