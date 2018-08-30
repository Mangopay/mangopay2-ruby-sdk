# MangoPay Ruby SDK [![Build Status](https://travis-ci.org/Mangopay/mangopay2-ruby-sdk.svg?branch=master)](https://travis-ci.org/Mangopay/mangopay2-ruby-sdk)

The new gem for interacting with the version 2.01 of the Mangopay API.
See the [API documentation](http://docs.mangopay.com/api-references/)
for more details on the API.

Tested on the following versions of Ruby: 2.4.1

## NEWS

### Version 4.*
**BREAKING CHANGES:** This version (4.\*) of the gem is targeting the Mangopay API Version 2.01. It has a brand new structure to make the api calls easier to use. It has not been tested for backward compatibility with 3.\* series.

For upgrading to v2.01 of the API, there is more information about the changes required [here](https://docs.mangopay.com/api-v2-01-overview/).

Account creation
-------------------------------------------------
You can get yourself a [free sandbox account](https://www.mangopay.com/signup/create-sandbox/) or sign up for a [production account](https://www.mangopay.com/signup/production-account/) (note that validation of your production account can take a few days, so think about doing it in advance of when you actually want to go live).

## Usage

### Install
* You can get yourself a [free sandbox account](https://www.mangopay.com/get-started/create-sandbox/) or sign up for a [production account](https://www.mangopay.com/signup/production-account/) (note that validation of your production account can take a few days, so think about doing it in advance of when you actually want to go live).

* Install the gem by either running ```gem install mangopay-v4```
or by adding it to your Gemfile ```gem 'mangopay-v4'```

* Using the credential info from the signup process above, call ```MangoPay.configure``` in your script as shown in the snippet below.

## Examples

A few examples which demonstrate making each type of request through the SDK V4, comparative to V3.

### Configure

#### V3 / V4

```ruby
require 'mangopay'

MangoPay.configure do |config|
 config.client_id = :CLIENT_ID
 config.client_apiKey = :CLIENT_PASS
 end
 ```

### Create a User

#### V3

```ruby
user_object = {
  Address: {
    AddressLine1: 'Test st., no. 18',
    AddressLine2: 'bl. 16, int. 32',
    City: 'Brasov',
    Region: 'Tractoru',
    PostalCode: '505600',
    Country: 'RO'
  },
  KYCLevel: 'LIGHT',
  Email: 'hello@moto.com',
  FirstName: 'Hi',
  LastName: 'Bye',
  Birthday: 1_300_186_358,
  Birthplace: 'Brasov',
  Nationality: 'RO',
  CountryOfResidence: 'RO',
  Occupation: 'Cowboy',
  IncomeRange: 1
}
 
created_user = MangoPay::NaturalUser.create user_object
 
created_user # => Hash object
```

#### V4

```ruby
address = MangoModel::Address.new
 
address.address_line1 = 'Test st., no. 18'
address.address_line2 = 'bl. 16, int. 32'
address.city = 'Brasov'
address.region = 'Tractoru'
address.postal_code = '505600'
address.country = MangoModel::CountryIso::RO
 
user_object = MangoModel::NaturalUser.new # or MangoModel::LegalUser.new
 
user_object.address = address
user_object.kyc_level = MangoModel::KycLevel::LIGHT
user_object.email = 'hello@moto.com'
user_object.first_name = 'Hi'
user_object.last_name = 'Bye'
user_object.birthday = 1_300_186_358
user_object.birthplace = 'Brasov'
user_object.nationality = MangoModel::CountryIso::RO
user_object.country_of_residence = MangoModel::CountryIso::RO
user_object.occupation = 'Cowboy'
user_object.income_range = MangoModel::IncomeRange::BETWEEN_50_80
 
created_user = MangoApi::Users.create user_object
 
created_user # => MangoModel::NaturalUser/MangoModel::LegalUser object
```

### Create a PayIn

#### V3

```ruby
natural_user = get_some_natural_user
 
wallet = MangoPay::Wallet.create({
  Owners: [user['Id']],
  Description: 'A test wallet',
  Currency: 'EUR',
  Tag: 'Test wallet'
})
 
created_pay_in = MangoPay::PayIn::Card::Web.create({
  AuthorId: natural_user['Id'],
  CreditedUserId: wallet['Owners'][0],
  CreditedWalletId: wallet['Id'],
  ReturnURL: 'http://www.my-site.com/returnURL/',
  CardType: 'CB_VISA_MASTERCARD',
  SecureMode: 'DEFAULT',
  Culture: 'FR',
  TemplateURLOptions: {
    Payline: 'https://www.mysite.com/template/'
  },
  StatementDescriptor: 'Mar2016',
  Tag: 'Create Card Web PayIn',
  DebitedFunds: {
    Currency: 'EUR',
    Amount: 1000
  },
  Fees: {
    Currency: 'EUR',
    Amount: 0
  }
})
 
created_pay_in # => Hash object
```

#### V4

```ruby
user = get_some_user
 
wallet = MangoModel::Wallet.new
wallet.owners = [user.id]
wallet.description = 'A test wallet'
wallet.currency = MangoModel::CurrencyIso::EUR
wallet.tag = 'Test wallet'
 
wallet = MangoApi::Wallets.create wallet
 
pay_in = MangoModel::CardWebPayIn.new
pay_in.author_id = user.id
pay_in.credited_user_id = wallet.owners[0].id
pay_in.credited_wallet_id = wallet.id
pay_in.return_url = 'http://www.my-site.com/returnURL/'
pay_in.card_type = MangoModel::CardType::CB_VISA_MASTERCARD
pay_in.secure_mode = MangoModel::SecureMode::DEFAULT
pay_in.culture = MangoModel::CultureCode::EN
pay_in.template_url_options = TemplateUrlOptions.new
pay_in.template_url_options.payline = 'https://www.mysite.com/template/'
pay_in.statement_descriptor = 'Mar2016'
pay_in.tag = 'Create Card Web PayIn'
pay_in.debited_funds = MangoModel::Money.new
pay_in.debited_funds.currency = MangoModel::CurrencyIso::EUR
pay_in.debited_funds.amount = 1000
pay_in.fees = MangoModel::Money.new
pay_in.fees.currency = MangoModel::CurrencyIso::EUR
pay_in.fees.amount = 0
 
pay_in = MangoApi::PayIns.create_card_web pay_in
 
pay_in # => MangoModel::CardWebPayIn object
```

### Update a User

#### V3

```ruby
natural_user = get_some_natural_user
 
updated_user = MangoPay::NaturalUser.update(natural_user['Id'] ,{
  Email: 'jack@email.com'
})
 
updated_user # => Hash object
```

#### V4

```ruby
any_user = get_some_user
 
any_user.email = 'jack@email.com'
 
updated_user = MangoApi::Users.update any_user
 
updated_user # => MangoModel::LegalUser / MangoModel::NaturalUser object
```

### Get a User by id

#### V3

```ruby
natural_user = get_some_natural_user
 
retrieved_user = MangoPay::LegalUser.fetch(natural_user['Id'])
 
retrieved_user # => Hash object
```

#### V4

```ruby
any_user = get_some_user
 
retrieved_user = MangoApi::Users.get(any_user.id)
 
retrieved_user # => MangoModel::NaturalUser / MangoModel::LegalUser object
```

### Get a PayIn by id

#### V3

```ruby
pay_in = get_some_pay_in
 
retrieved_pay_in = MangoPay::PayIn.fetch(pay_in['Id'])
 
retrieved_pay_in # => Hash object
```

#### V4

```ruby
pay_in = get_some_pay_in
 
retrieved_pay_in = MangoApi::PayIns.get(pay_in.id)
 
retrieved_pay_in # => MangoModel::PayIn object
```

### List users

#### V3

```ruby
users = MangoPay::User.fetch
 
users # => Array of Hash object
```

#### V4

```ruby
users = MangoApi::Users.all
 
users # => Array of MangoModel::Dispute objects
```

### Sorting, Paging, Filtering

#### V3

```ruby
wallet = get_some_wallet
 
transactions = MangoPay::Transaction.fetch(wallet['Id'], {
  'page' => 2,
  'per_page' => 3,
  'sort' => 'CreationDate:DESC',
  'Nature' => 'REGULAR',
  'Type' => 'PAYIN'
})
 
transactions # => Array of corresponding Hash objects
```

#### V4

In the new version, any API method which allows filtering of the result list will yield a FilterRequest object which has fields for every possible filtering parameter. See methods' documentation to learn what parameters are available for each call.

```ruby
wallet = get_some_wallet
 
transactions = MangoApi::Transactions.of_wallet(wallet.id) do |filter|
  filter.page = 2
  filter.per_page = 3
  filter.sort_field = MangoPay::SortField::CREATION_DATE
  filter.sort_direction = MangoPay::SortDirection::ASC
  filter.nature = MangoModel::TransactionNature::REGULAR
  filter.type = MangoModel::TransactionType::PAYIN
end
 
transactions # => Array of corresponding MangoModel::Transaction objects
```

###### See the files in `'lib/mangopay/api/service'` and documentation for more info
 
### Error Handling

Similar in V4 as it was in V3
 
```ruby
begin
  MangoApi::Users.create user
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

## New Features

### The `MangoPay::Environment` Object

Use Environments to specify multiple MangoPay configurations within the same program. Specify the environment you want to switch to by using
```ruby
require 'mangopay'

MangoPay.use_environment :env_id # Symbol
MangoPay.configure do |config|
  config.client_id = 'first_id'
  config.client_apiKey = 'first_pass'
end
MangoPay.use_environment :env2
MangoPay.configure do |config|
  config.client_id = 'second_id'
  config.client_apiKey = 'second_pass'
end
MangoPay.use_environment :env1
config = MangoPay.configuration
config.client_id # => 'first_id'
MangoPay.use_environment :env2
config = MangoPay.configuration
config.client_id # => 'second_id'
```
They all get stored in memory - only OAuth Tokens may be kept in files.
#####`MangoPay.configure` must be called from each new Environment.
######Of course, you can just call `MangoPay.configure` without specifying an environment, and all calls will be made under an automatically-assigned `:default` Environment. 
#####Environments are Thread-specific for the duration of that Thread's lifetime.
This is done by Mapping each Thread's Ruby `Object.object_id` to the ID of the currently-active Environment. Configurations and other stuff like Rate Limits are stored in the Environment object obtainable context-specifically with a call to `MangoPay.environment` (i.e. Rate Limits and Configuration etc. of the Client will be Environment-specific). The relationship will be deleted as soon as the Thread dies, but the Environment remains correctly-configured to be used from any other Threads.
#####A new Thread will be assigned the most recently used Environment
...unless another has meanwhile been switched to, in which case it will be that one (i.e. Environment specified in the last call to `MangoPay.use_environment` or the `:default` Environment if none were made). All calls made from any Thread in the same Environment will return results pertaining to the configuration specified for that specific environment.
######This allows for various calls to be made in rapid succession with results dependent on each other without interfering with Configurations used on other Threads' Environments. 

See the `MangoPay` module, the `Environment` and `Configuration` classes and documentation for more info.

## Examples

### See tests for explicit examples of configuration and virtually all API calls.

##### You can run all tests quickly with `rspec` command or configure RubyMine to run an RSpec configuration of all specs in folder `'spec/mangopay'`, or of a single file for targeted debugging.

Specific tests can be run as well, by passing a `:focus` parameter along with the test's description string (see `'spec_helper.rb'` for more info)