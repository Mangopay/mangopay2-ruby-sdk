## [3.0.37] - 2020-10-20
- Card Validation endpoint fully activated

## [3.0.36] - 2020-08-28
- Forces TLS version to 1.2

## [3.0.35] - 2020-08-24
- Improvement to Net::ReadTimeout handling
- "User-agent" format in the headers changed, aligned to other assets 👤
 
## [3.0.34] - 2020-06-25
### Added
- This SDK is now GooglePay-ready ! Feel free to ask our lovely support for more infos about its activation.
- `UBODeclaration` is now directly available through its ID.
- If a bankwire is done from a UK bankaccount on one of your `BankingAlias`, you could find its `AccountNumber` on `GET /payins/` response
- You can now send a `Culture` parameter for Paypal PayIns. Thanks to it, payment page can be displayed in various languages.

### Changed
- `PAYLINEV2`value for Payin Web has been added on `TemplateURLOptions` object. You now should use it instead of `PAYLINE` for page customization.

### Fixed
- Missing filters parameters have been added
- You can now send headers in update requests
- Loggers have been enhanced

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


 
