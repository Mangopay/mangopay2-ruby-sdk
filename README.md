# Mangopay Ruby SDK

[![Gem Version](https://badge.fury.io/rb/mangopay.svg)](https://rubygems.org/gems/mangopay) 

Official [Mangopay Gem](https://rubygems.org/gems/mangopay) to access the [Mangopay API](https://docs.mangopay.com/api-reference) from applications written in Ruby.

See the [Mangopay API documentation](https://docs.mangopay.com/) for Ruby samples and details on product features. See the [SDK tests](#tests) for further usage examples.

## Prerequisites
- * A `ClientId` and an API key – if you don't have these, <a href="https://mangopay.com/contact" target="_blank">contact Sales</a> to get access to the <a href="https://hub.mangopay.com/" target="_blank">Mangopay Dashboard</a>
- Ruby 1.9.2 or higher (tested from 1.9.2 up to 3.4.4)

Since SDK [v3.0.17](https://github.com/Mangopay/mangopay2-ruby-sdk/releases/tag/v3.0.17), the library uses v2.01 of the API. The older API version (v2) is no longer available.

## Installation

* Install the gem by either running ```gem install mangopay```
or by adding it to your Gemfile ```gem 'mangopay'```

* Call ```MangoPay.configure``` in your script as shown in the snippet below.

### Usage

```ruby
require 'mangopay'


# configuration
MangoPay.configure do |c|
  c.preproduction = true
  c.client_id = 'YOUR_CLIENT_ID'
  c.client_apiKey = 'YOUR_CLIENT_API_KEY'
  c.log_file = File.join('mypath', 'mangopay.log')
  c.http_timeout = 10000
end


# get some user by id
john = MangoPay::User.fetch(john_id) # => {FirstName"=>"John", "LastName"=>"Doe", ...}


# update some of his data
MangoPay::NaturalUser.update(john_id, {'LastName' => 'CHANGED'}) # => {FirstName"=>"John", "LastName"=>"CHANGED", ...}


# get all users (with pagination)
pagination = {'page' => 1, 'per_page' => 8} # get 1st page, 8 items per page
users = MangoPay::User.fetch(pagination) # => [{...}, ...]: list of 8 users data hashes
pagination # => {"page"=>1, "per_page"=>8, "total_pages"=>748, "total_items"=>5978}

# pass custom filters (transactions reporting filters)
filters = {'MinFeesAmount' => 1, 'MinFeesCurrency' => 'EUR', 'MaxFeesAmount' => 1000, 'MaxFeesCurrency' => 'EUR'}
reports = MangoPay::Report.fetch(filters) # => [{...}, ...]: list of transaction reports between 1 and 1000 EUR

# get John's bank accounts
accounts = MangoPay::BankAccount.fetch(john_id) # => [{...}, ...]: list of accounts data hashes (10 per page by default)


# error handling
begin
  MangoPay::NaturalUser.create({})
rescue MangoPay::ResponseError => ex

  ex # => #<MangoPay::ResponseError: One or several required parameters are missing or incorrect. [...] FirstName: The FirstName field is required. LastName: The LastName field is required. Nationality: The Nationality field is required.>

  ex.details # => {
             #   "Message"=>"One or several required parameters are missing or incorrect. [...]",
             #   "Type"=>"param_error",
             #   "Id"=>"5c080105-4da3-467d-820d-0906164e55fe",
             #   "Date"=>1409048671.0,
             #   "errors"=>{
             #     "FirstName"=>"The FirstName field is required.",
             #     "LastName"=>"The LastName field is required.", ...},
             #   "Code"=>"400",
             #   "Url"=>"/v2/.../users/natural"
             # }
end
```

### Using multiple Client IDs 
The Ruby SDK offers the option to create multiple configuration objects tailored to your specific needs:

```
config = MangoPay::Configuration.new
config.client_id = 'your-client-id'
config.client_apiKey = 'your-api-key'
config.preproduction = true
```

Add them using:

`MangoPay.add_config('config1', config)`

And perform a call with them using:

`MangoPay.get_config('config1').apply_configuration`

The previous method `configure()` is still working.

### Accessing rate limiting headers
The API returns rate limiting headers which are automatically updated in the `MangoPay` object:

* X-RateLimit-Limit
* X-RateLimit-Remaining
* X-RateLimit-Reset

```
  MangoPay.ratelimit

  {
    :limit=>["74", "74", "75", "908"],
    :remaining=>["2226", "4426", "8725", "104692"],
    :reset=>["1495615620", "1495616520", "1495618320", "1495701060"]
  }
```

For more information, see the [rate limiting](https://docs.mangopay.com/api-reference/overview/rate-limiting) article on the Mangopay docs.

### Log requests and responses
You can enable logs by setting the ```log_file``` configuration option (see [usage](#usage) above). If you don't want logs, remove the ```log_file``` line.

Requests and responses are filtered, so confidential data is not saved in logs.

### Tests
Make sure that you have run: 
```
bundle install
```
Then to run the test suite, run: 
```
rspec
```

## Issues

Create a [GitHub issue](https://github.com/Mangopay/mangopay2-ruby-sdk/issues) to report any problems or request features.

We aim to reply to issues and contributions in a timely manner. For additional followup or anything that can't be shared over GitHub, please get in touch with our Support teams via the <a href="https://hub.mangopay.com/" target="_blank">Mangopay Dashboard</a>.

## Contributing

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle && bundle exec rspec`

3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

4. Make the test pass.

5. Push to your fork and submit a pull request.

Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Prefer &&/|| over and/or.
* MyClass.my_method(my_arg) not my_method( my_arg ) or my_method my_arg.
* a = b and not a=b.
* Follow the conventions you see used in the source already.