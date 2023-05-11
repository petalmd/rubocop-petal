# RuboCop::Petal

[![Build](https://github.com/petalmd/rubocop-petal/actions/workflows/build.yml/badge.svg)](https://github.com/petalmd/rubocop-petal/actions/workflows/build.yml)
[![Gem Version](https://badge.fury.io/rb/rubocop-petal.svg)](https://badge.fury.io/rb/rubocop-petal)

Petal custom cops. List of cops can be find [here](https://github.com/petalmd/rubocop-petal/tree/main/lib/rubocop/cop).

Petal global gem configuration for:

* rubocop
* rubocop-rspec
* rubocop-performance
* rubocop-rails
* rubocop-petal

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

In your `.rubocop.yml` file, add 

```yaml
inherit_gem:
  rubocop-petal: 'config/base.yml'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To run all checks like the CI simply run `bundle exec rake`.

## Create new cop

```shell
bundle exec rake 'new_cop[Rails/MyNewCop]'
```

Have a look to [RuboCop documentation](https://docs.rubocop.org/rubocop/1.23/development.html) to get started with
_node pattern_.

## Release

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petalmd/rubocop-petal.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
