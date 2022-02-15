# WeShipClient

This is a Ruby client for the We Ship Express V2 API provided by https://www.weshipexpress.com/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'we_ship_client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install we_ship_client


## Usage

First, set the required environment variables and load them in your app, using your preferred method (dotenv, figaro etc.).
See `.env.example` for a reference.

### Get Tracking

```ruby
auth_token = WeShipClient::TokenClient.new.generate_access_token

request = WeShipClient::Entities::TrackRequest.new(
  customer_code: [ENV['WE_SHIP_CUSTOMER_CODE']],
  internal_tracking_num: [your_tracking_number]
)

response = WeShipClient::Interactors::GetTracking.new(
  auth_token: auth_token,
  track_request: request
).call
```

### Process Orders

```ruby
auth_token = WeShipClient::TokenClient.new.generate_access_token

orders = [
  WeShipClient::Entities::Order.new(
    orderNo: 'ABC123',
    orderDate: '2021-01-01',
    shipMethod: '',
    fulfillmentLocation: 'XXX',
    shipToAddress: WeShipClient::Entities::Address.new(
      name: 'Name',
      address1: 'Address 1'
      address2: 'Address 2',
      city: 'New York',
      state: 'NY',
      postalCode: '12345',
      country: 'US',
      homePhone: '+123456789'
    ),
    orderItems: WeShipClient::Entities::OrderItems.new(
      orderItem: [
        WeShipClient::Entities::OrderItem.new(
          productName: 'Item name',
          productSKU: 'SKU',
          productType: 'XXX',
          quantity: 1,
          weight: '10'
        )
      ]
    )
  )
]

request = WeShipClient::Entities::ProcessOrdersRequest.new(
  clientCode: ENV['WE_SHIP_CUSTOMER_CODE'],
  order: orders
)

response = WeShipClient::Interactors::ProcessOrders.new(
  auth_token: auth_token,
  process_orders_request: request
).call
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To execute tests, run `bundle exec rake spec`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JuulLabs-OSS/we_ship_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Test project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/JuulLabs-OSS/we_ship_client/blob/master/CODE_OF_CONDUCT.md).


