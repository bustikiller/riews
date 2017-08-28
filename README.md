# Riews

[![Build Status](https://semaphoreci.com/api/v1/bustikiller/riews/branches/master/badge.svg)](https://semaphoreci.com/bustikiller/riews)
[![security](https://hakiri.io/github/bustikiller/riews/master.svg)](https://hakiri.io/github/bustikiller/riews/master)
[![Coverage Status](https://coveralls.io/repos/github/bustikiller/riews/badge.svg?branch=master)](https://coveralls.io/github/bustikiller/riews?branch=master)

Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'riews', git: 'https://github.com/bustikiller/riews'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install riews
```

Please, take into account that there is no stable release yet.

### Mounting the routes
Add this line to your application's routes file:
```ruby
mount Riews::Engine, at: '/riews', as: :riews
```

### Executing the migrations
Import and execute the migrations:
```bash
rake riews:install:migrations
rake db:migrate
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
