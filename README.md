# Tikkie API

[![Gem Version](https://badge.fury.io/rb/tikkie-api.svg)](https://badge.fury.io/rb/tikkie-api)
[![Build Status](https://travis-ci.org/KentaaNL/tikkie-api.svg?branch=master)](https://travis-ci.org/KentaaNL/tikkie-api)
[![Code Climate](https://codeclimate.com/github/KentaaNL/tikkie-api/badges/gpa.svg)](https://codeclimate.com/github/KentaaNL/tikkie-api)

Unofficial Ruby library for communicating with the [Tikkie API](https://developer.abnamro.com/content/tikkie).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tikkie-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tikkie-api

## Usage

### Preparation

This library uses a JSON Web Token (JWT) as authentication method. You need to create a public/private key pair to sign the tokens.
See the [developer documentation from ABN AMRO](https://developer.abnamro.com/get-started#authentication) to get started.

Make sure you have created an App in the developers portal with the Tikkie API product enabled. This App contains a Consumer Key (this is your API key), which you will need next.

### Initialization

First create a Tikkie configuration and specify the API key of your App and the path to your private RSA key. Then use the configuration to initialize a Tikkie client:

```ruby
require 'tikkie/api'

config = Tikkie::Api::Configuration.new("your_api_key", "private_rsa.pem")
client = Tikkie::Api::Client.new(config)
```

The configuration is created for the production environment by default. If you want to use the sandbox testing environment, then add the option `test: true` when creating the configuration:

```ruby
config = Tikkie::Api::Configuration.new("your_api_key", "private_rsa.pem", test: true)
```

### Platforms

Retrieve all platforms:

```ruby
platforms = client.platforms.list
```

Create a new platform:

```ruby
platform = client.platforms.create(
  name: "Kentaa",
  phone_number: "0601234567",
  platform_usage: Tikkie::Api::Types::PlatformUsage::FOR_MYSELF,
  email: "info@kentaa.nl",                      # optional
  notification_url: "https://kentaa.nl/tikkie"  # optional
)

platform_token = platform.platform_token
```

### Users

Retrieve all users for a platform:

```ruby
users = client.users.list("platform_token")
```

Create a new user for a platform:

```ruby
user = client.users.create("platform_token",
  name: "Kentaa",
  phone_number: "0601234567",
  iban: "NL02ABNA0123456789",
  bank_account_label: "Personal account"
)

user_token = user.user_token
bank_account_token = user.bank_accounts.first.bank_account_token
```

### Payment requests

Retrieve all payment requests for a user on a platform:

```ruby
payment_requests = client.payment_requests.list("platform_token", "user_token")
```

The payments requests response is paginated. You can use the method `more_elements?` to determine if there's more data to retrieve. In the next request, set the `offset` parameter to the new offset using the method `next_offset` from the previous response. For example:

```ruby
options = {}

loop do
  payment_requests = client.payment_requests.list("platform_token", "user_token", options)

  # Do something with payment requests

  break unless payment_requests.more_elements?

  options[:offset] = payment_requests.next_offset
end
```

To retrieve a single payment request:

```ruby
payment_request = client.payment_requests.get("platform_token", "user_token", "payment_request_token")
```

Create a new payment request (i.e. Tikkie) for an existing user:

```ruby
payment_request = client.payment_requests.create("platform_token", "user_token", "bank_account_token",
  amount: "5.00",               # optional
  currency: "EUR",
  description: "Test",
  external_id: "Invoice 12345"  # mandatory only when platform_usage is set to `FOR_MYSELF`
)

tikkie_url = payment_request.payment_request_url
payment_request_token = payment_request.payment_request_token
```

The parameter `amount` is optional. When omitted, it will create a payment request with an open amount, where the payer can decide on the amount.

### Error handling

All responses to an API request include the methods `success?` and `error?` to determine whether the API call was successful or not. When the API request was not successful, the method `errors` will return details about the error response.

```ruby
payment_request = client.payment_requests.create("platform_token", "user_token", "bank_account_token", ...)

if payment_request.success?
  # Success handling...

  redirect_to payment_request.payment_request_url
else
  # Error handling...

  puts payment_request.errors.inspect
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KentaaNL/tikkie-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
