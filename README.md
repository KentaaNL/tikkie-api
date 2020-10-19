# Tikkie API

[![Gem Version](https://badge.fury.io/rb/tikkie-api.svg)](https://badge.fury.io/rb/tikkie-api)
[![Build Status](https://travis-ci.org/KentaaNL/tikkie-api.svg?branch=master)](https://travis-ci.org/KentaaNL/tikkie-api)
[![Code Climate](https://codeclimate.com/github/KentaaNL/tikkie-api/badges/gpa.svg)](https://codeclimate.com/github/KentaaNL/tikkie-api)

Unofficial Ruby library for communicating with the [Tikkie API](https://developer.abnamro.com/api-products/tikkie).

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Payment requests](#payment-requests)
    - [Create a Payment request](#create-a-payment-request)
    - [List Payment requests](#list-payment-requests)
    - [Get Payment request](#get-payment-request)
  - [Payments](#payments)
    - [List Payments](#list-payments)
    - [Get Payment](#get-payment)
  - [Refunds](#refunds)
    - [Create a Refund](#create-a-refund)
    - [Get Refund](#get-refund)
  - [Payment requests notification](#payment-requests-notification)
    - [Create a subscription](#create-a-subscription)
    - [Delete subscription](#delete-subscription)
  - [Sandbox apps](#sandbox-apps)
    - [Create a Sandbox app](#create-a-sandbox-app)
- [Error handling](#error-handling)
- [Notifications](#notifications)
- [API support](#api-support)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tikkie-api', '~> 2.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tikkie-api

## Usage

Create a Tikkie client using your API key and an App token. If you don't have an App token yet, please read the [documentation about App tokens](https://developer.abnamro.com/api-products/tikkie/reference-documentation#section/Overview) or use the [Sandbox apps endpoint](#sandbox-apps) to create an App token in the sandbox environment.

```ruby
require 'tikkie/api'

client = Tikkie::Api::Client.new(api_key: "12345", app_token: "abcdef")
```

The client is created for the production environment by default. If you want to use the sandbox environment, then add `sandbox: true`:

```ruby
client = Tikkie::Api::Client.new(api_key: "12345", app_token: "abcdef", sandbox: true)
```

### Payment requests

#### Create a Payment request

Creates a new payment request. When the parameter `amount` is omitted, it will create a payment request with an open amount, where the payer can decide on the amount.

```ruby
payment_request = client.payment_requests.create(
  description: "Test",           # mandatory
  amount: "12.50",
  expiry_date: "2021-01-01",
  reference_id: "Invoice 12345"
)

payment_request.payment_request_token  # => "qzdnzr8hnVWTgXXcFRLUMc"
payment_request.url  # => "https://tikkie.me/pay/Tikkie/qzdnzr8hnVWTgXXcFRLUMc"
payment_request.amount  # => BigDecimal("12.50")
```

See [Tikkie::Api::Resources::PaymentRequest](lib/tikkie/api/resources/payment_request.rb) for all available properties.

#### List Payment requests

Retrieves all payment requests.

```ruby
payment_requests = client.payment_requests.list
```

The payments requests response is paginated. You can iterate through the pages using `payment_requests.next` and checking the result:

```ruby
payment_requests = client.payment_requests.list

loop do
  # Do something with payment requests

  payment_requests = payment_requests.next
  break if payment_requests.nil?
end
```

See [Tikkie::Api::Resources::PaymentRequests](lib/tikkie/api/resources/payment_requests.rb) for all available properties.

#### Get Payment request

Retrieve details of a specific payment request.

```ruby
payment_request = client.payment_requests.get("payment_request_token")

payment_request.payment_request_token  # => "qzdnzr8hnVWTgXXcFRLUMc"
payment_request.url  # => "https://tikkie.me/pay/Tikkie/qzdnzr8hnVWTgXXcFRLUMc"
payment_request.amount  # => BigDecimal("12.50")
payment_request.payments  # => Tikkie::Api::Resources::Payments
```

See [Tikkie::Api::Resources::PaymentRequest](lib/tikkie/api/resources/payment_request.rb) for all available properties.


### Payments

#### List Payments

Retrieves all payments for a specific payment request.

```ruby
payments = client.payments.list("payment_request_token")
```

The payments requests response is paginated. You can iterate through the pages using `payments.next` and checking the result:

```ruby
payments = client.payments.list("qzdnzr8hnVWTgXXcFRLUMc")

loop do
  # Do something with payments

  payments = payments.next
  break if payments.nil?
end
```

See [Tikkie::Api::Resources::Payments](lib/tikkie/api/resources/payments.rb) for all available properties.

#### Get Payment

Retrieves details of specific payment based on the token value.

```ruby
payment = client.payments.get("payment_request_token", "payment_token")

payment.payment_token  # => "21ef7413-cc3c-4c80-9272-6710fada28e4"
payment.amount  # => BigDecimal("12.50")
payment.description  # => "Test"
payment.refunds  # => Array[Tikkie::Api::Resources::Refund]
```

See [Tikkie::Api::Resources::Payment](lib/tikkie/api/resources/payment.rb) for all available properties.

### Refunds

#### Create a Refund

Creates a refund for a specific payment.

```ruby
refund = client.refunds.create("payment_request_token", "payment_token",
  description: "Test",           # mandatory
  amount: "10.00",               # mandatory
  reference_id: "Invoice 12345"
)

refund.refund_token  # => "abcdzr8hnVWTgXXcFRLUMc"
refund.amount  # => BigDecimal("10.00")
refund.paid?   # => true
```

See [Tikkie::Api::Resources::Refund](lib/tikkie/api/resources/refund.rb) for all available properties.

#### Get Refund

Retrieves details of a specific refund based on the token value.

```ruby
refund = client.refunds.get("payment_request_token", "payment_token", "refund_token")

refund.refund_token  # => "abcdzr8hnVWTgXXcFRLUMc"
refund.amount  # => BigDecimal("10.00")
refund.paid?   # => true
```

See [Tikkie::Api::Resources::Refund](lib/tikkie/api/resources/refund.rb) for all available properties.

### Payment requests notification

See [Notifications](#notifications) for information about parsing the callbacks.

#### Create a subscription

Subscribes to payment request related notifications.

```ruby
subscription = client.payment_requests_subscription.create(url: "https://www.example.com/notification")

subscription.subscription_id  # => "e0111835-e8df-4070-874a-f12cf3f77e39"
```

See [Tikkie::Api::Resources::PaymentRequestsSubscription](lib/tikkie/api/resources/payment_requests_subscription.rb) for all available properties.

#### Delete subscription

Deletes the current subscription.

```ruby
client.payment_requests_subscription.delete
```

### Sandbox apps

A sandbox app is used to make API requests in the sandbox environment.

You must initialize the Tikkie client by omitting the App token and adding the option `sandbox: true`:

```
client = Tikkie::Api::Client.new(api_key: "12345", sandbox: true)
```

#### Create a Sandbox app

Creates an app in the sandbox. The returned `app_token` should be used for all other API operations.

```ruby
sandbox_app = client.sandbox_apps.create

sandbox_app.app_token  # => "935059a6-58b3-4f8d-a021-7bdda0d8d6ad"
```

See [Tikkie::Api::Resources::SandboxApp](lib/tikkie/api/resources/sandbox_app.rb) for all available properties.

## Error handling

All responses that are not HTTP status 20x will result in a [Tikkie::Api::RequestError](lib/tikkie/api/exception.rb).

```ruby
begin
  client.payment_requests.get("invalid")
rescue Tikkie::Api::RequestError => e
  e.http_code # => 404
  e.http_message # => Not Found
  e.errors # => Array[Tikkie::Api::Resources::Error]
  e.messages # => "No payment request was found for the specified paymentRequestToken."
end
```

## Notifications

When subscribed to notifications, you can use `Tikkie::Notification.parse` to parse the payload of a callback.

```ruby
require 'tikkie/notification'

notification = Tikkie::Notification.parse(request.raw_post)

notification  # => Tikkie::Notifications::PaymentNotification
notification.subscription_id  # => "e0111835-e8df-4070-874a-f12cf3f77e39"
notification.notification_type  # => "PAYMENT"
notification.payment_request_token  # => "qzdnzr8hnVWTgXXcFRLUMc"
notification.payment_token  # => "21ef7413-cc3c-4c80-9272-6710fada28e4"
```

See [Tikkie::Notifications](lib/tikkie/api/notifications/) for all types of notifications.

## API support

This gem supports [Tikkie API (v2)](https://developer.abnamro.com/api-products/tikkie) as of release 2.0.0.

The deprecated [Tikkie Payment Request API (v1)](https://developer.abnamro.com/api-products/tikkie-payment-request)) is currently namespaced under [Tikkie::Api::V1](lib/tikkie/api/v1/) to allow migration to Tikkie v2. This code is not supported anymore and will be removed in a future release of this gem.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KentaaNL/tikkie-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
