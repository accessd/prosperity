# Prosperity

[![Build Status](https://travis-ci.org/smathieu/prosperity.png)](https://travis-ci.org/smathieu/prosperity)

Prosperity easily lets you add a dashboard of arbitrary time series data to your rails app.

![Screenshot](https://raw2.github.com/smathieu/prosperity/master/doc/screenshot.png "Prosperity")

## Install

Add this line to your application's Gemfile:

```
gem 'prosperity'
```

And then execute:

```bash
bundle
bundle exec rake db:migrate
```

Add a route to prosperity in ```config/routes.rb```.

```ruby
mount Prosperity::Engine => "/prosperity"
```

You can then generate your first metric.

```bash
rails g metric Users
```

This will generate app/prosperity/user_metric.rb

You can add custom scopes like so:

```ruby
class UsersMetric < Prosperity::Metric
  scope { User }

  options 'active' do |scope|
    scope.where(state: 'active')
  end
end
```

## Development

To get started with a development environment with [pow](http://pow.cx/), follow these instructions;

```bash
git clone https://github.com/smathieu/prosperity.git
ln -s `pwd`/prosperity/spec/dummy ~/.pow/prosperity
cd prosperity
bundle
rake db:create db:migrate RAILS_ENV=test
```

and to run the tests;
```bash
bundl exec rspec
```

## License

This project rocks and uses MIT-LICENSE.

## Todo

See [Issues](https://github.com/smathieu/prosperity/issues?labels=enhancement&page=1&state=open)
