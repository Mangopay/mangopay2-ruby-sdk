# MangoPay SDK v4 Migration guide

## Introduction 

The current version of MangoPay Ruby SDK ([v3 branch](https://github.com/Mangopay/mangopay2-ruby-sdk/tree/master)) is not 
taking advantage of the type safety offered by Ruby language. V4 of this SDK is introducing an object oriented way of 
integrating with MangoPay services. 

It introduces a comprehensive collection of models containing typed field fields, which has many benefits: 
 * Spot code errors early: the IDE will flag any type mismatch immediately and the build will also fail
 * Easier and safer refactoring of code
 * This kind of bugs are discovered by the developers, not by the users at runtime, in production
 * More accurate code autocomplete in any modern Code Editor / IDE.

## V3 vs V4 comparison

Switching to v4 requires a major code rewrite though. Let's take, for example, user creation as an example.

On V3, creating an user can be done like this:

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

First step is to create a hash with the required structure, pass it to the MangoPay::NaturalUser service, and the 
response from MangoPay API will be returned and stored in created_user hash. Here we can already see many points of 
failure:

 * The hash that is sent to the MangoPay::NaturalUser service is not checked if it contains correct data
 * Any hash sent to it will be passed to the MangoPay API, and only then we can see that the hash is not correct
 * The code will be built successfully with a wrong hash because it's correct, from Ruby's perspective (it is just
   a hash, no schema is defined here)

On the other hand, in V4, user creation is done like the following:

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

We can already see that we are using classes (Address, NaturalUser, LegalUser) to interact with the MangoPay API. You
can set only the fields that are declared in the classes. Some of the advantages of this are the following:

 * No more hashes to interact with the API. We have classes which reflects the requirements of the API
 * Only valid objects can be sent to the Users service. e.g. you cannot pass an Address object to the Users.create method
 * The code will fail to build if wrong objects are sent to methods or if unknown fields are set to the objects (typos, for example)

## Migration steps

In order to migrate to V4, you need to follow these steps:
 1. Replace the V3 gemfile with the V4 ```gem 'mangopay-v4'```
 2. Go through all Mangopay code and replace Hashes with the new classes introduced by V4

All the API interactions are tested in this repository, you can find examples of how to interact with sdk v4 
[here](https://github.com/Mangopay/mangopay2-ruby-sdk/tree/v4/spec/mangopay).