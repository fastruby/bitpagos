# Bitpagos API
Ruby wrapper for the Bitpagos payments API

[![Gem Version](https://badge.fury.io/rb/bitpagos.svg)](http://badge.fury.io/rb/bitpagos)
[![Build Status](https://travis-ci.org/ombulabs/bitpagos.svg?branch=master)](https://travis-ci.org/ombulabs/bitpagos)

## Getting Started

For command line usage:

```bash
$ gem install bitpagos
```

If you intend to use it within an application, add `gem "bitpagos"` to your
`Gemfile`.

## Usage

After installing the gem, you need to obtain your Bitpagos API key from their
website, in your control panel, [here](https://www.bitpagos.com/api/settings).

Initialize a Bitpagos client by running:

```ruby
your_api_key = "ABCDEFG123456789"
client = Bitpagos::Client.new(your_api_key)
```

To get a transaction by its id:

```ruby
client.get_transaction("12345")
```

To get only the completed or waiting transactions:

```ruby
result = client.completed_transactions

result = client.waiting_transactions
```

You can also use the `#transactions` method like this:

```ruby
result = client.transactions(status: :completed)

result = client.transactions(status: :waiting)
```

Pagination is available by providing limit and offset:

```ruby
result = client.transactions({status: :completed, limit: 20, offset: 60})
```

## Contributing & Development

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your feature (and tests)
4. Run tests (`bundle exec rake`)
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## Release the Gem

```bash
$ bundle exec rake release
```
