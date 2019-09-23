## [Unreleased]
### New v4 SDK version (available as a beta version here: https://rubygems.org/gems/mangopay-v4) - will be shortly merged on master.

## [3.0.33] - 2019-09-23
### Added
- ApplePay `Payin` functions are now available. More info about activation to come in the following weeks...  
### Changed
- GET EMoney method now supports year and month parameters. More info on our [docs](https://docs.mangopay.com/endpoints/v2.01/user-emoney#e895_view-a-users-emoney)

## [v3.0.32] - 2019-06-19
### Added
- New UBO Declaration system (more info [here](https://docs.mangopay.com/endpoints/v2.01/ubo-declarations#e1024_the-ubo-declaration-object))
### Changed
- Paypal buyer account email that has been used is now available for Payin Paypal
- Your `HeadquartersPhoneNumber` can now be updated for your client account directly from our API
### BREAKING
- `APIKey` is now replacing `passphrase` property for credentials. You must update it by updating to 3.0.32 SDK version and upper ones.


 
