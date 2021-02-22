# Mangopay Ruby SDK [![Build Status](https://travis-ci.org/Mangopay/mangopay2-ruby-sdk.svg?branch=master)](https://travis-ci.org/Mangopay/mangopay2-ruby-sdk)

The gem for interacting with the version 2 of the Mangopay API.
See the [API documentation](http://docs.mangopay.com/api-references/)
for more details on the API.

Tested on the following versions of Ruby: 1.9.2, 1.9.3, 2.0.0 and 2.x up to 2.5

## NEWS

### Version 3.*
**BREAKING CHANGES:** This version (3.\*) of the gem is targeting the Mangopay API Version 2. It has a brand new structure to make the api calls easier to use and is not backward compatible with 2.\* series.

Since [v3.0.17](https://github.com/Mangopay/mangopay2-ruby-sdk/releases/tag/v3.0.17) of the SDK, you must be using at least v2.01 of the API (more information about the changes required [here](https://docs.mangopay.com/api-v2-01-overview/))

Account creation
-------------------------------------------------
You can get yourself a free sandbox account or sign up for a production account by [registering on the Mangopay site](https://www.mangopay.com/start/) (note that validation of your production account involves several steps, so think about doing it in advance of when you actually want to go live).

## Usage

### Install
* You can get yourself a free sandbox account or sign up for a production account [on the Mangopay site](https://www.mangopay.com/start/) (note that validation of your production account will involve several steps, so think about doing it in advance of when you actually want to go live).

* Install the gem by either running ```gem install mangopay```
or by adding it to your Gemfile ```gem 'mangopay'```

* Using the credential info from the signup process above, call ```MangoPay.configure``` in your script as shown in the snippet below.

### Examples

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

### Accessing RateLimit Headers
Along with each request, the rate limiting headers are automatically updated in MangoPay object:

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

Read more about rate limiting on [our documentation](https://docs.mangopay.com/guide/rate-limiting).

### Log requests and responses
You can easily enable logs by setting the ```log_file``` configuration option (see the section **configuration** above). If you don't want logs, remove the ```log_file``` line.

Requests and responses are filtered, so confidential data is not saved in logs.

### Tests
Make sure that you have run: ```bundle install```
Then you just have to run rspec ```rspec``` to run all the test suite.
Feel free to report any test failure by creating an issue
on the [Gem's Github](https://github.com/Mangopay/mangopay2-ruby-sdk/issues)

## Contributing

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle && bundle exec rspec`

3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

4. Make the test pass.

5. Push to your fork and submit a pull request.

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within three business days (and, typically, one business
day). We may suggest some changes or improvements or alternatives.

Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Prefer &&/|| over and/or.
* MyClass.my_method(my_arg) not my_method( my_arg ) or my_method my_arg.
* a = b and not a=b.
* Follow the conventions you see used in the source already.

A contribution can also be as simple as a +1 on issues tickets to show us
what you would like to see in this gem.

That's it for now. Good Hacking...
