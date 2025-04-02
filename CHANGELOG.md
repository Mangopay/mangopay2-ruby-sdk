## [3.30.2] - 2025-04-02
### Fixed
- Fixed the way User-Agent Header is built

## [3.30.1] - 2025-04-02
### Changed
- User-Agent Header value standardized on format: User-Agent: Mangopay-SDK/`SDKVersion` (`Language`/`LanguageVersion`)

## [3.30.0] - 2025-03-24
### Added

New endpoints for [strong customer authentication (SCA)](https://docs.mangopay.com/guides/users/sca) on Owner users:
- [POST Create a Natural User (SCA)](https://docs.mangopay.com/api-reference/users/create-natural-user-sca)
- [PUT Update a Natural User (SCA)](https://docs.mangopay.com/api-reference/users/update-natural-user-sca)
- [POST Create a Legal User (SCA)](https://docs.mangopay.com/api-reference/users/create-legal-user-sca)
- [PUT Update a Legal User (SCA)](https://docs.mangopay.com/api-reference/users/update-legal-user-sca)
- [PUT Categorize a Natural User (SCA)](https://docs.mangopay.com/api-reference/users/categorize-natural-user)
- [PUT Categorize a Legal User (SCA)](https://docs.mangopay.com/api-reference/users/categorize-legal-user)
- [POST Enroll a User in SCA](https://docs.mangopay.com/api-reference/users/enroll-user)

## [3.29.0] - 2025-02-26
### Added

Endpoints and webhooks for [hosted KYC/B solution](https://docs.mangopay.com/guides/users/verification/hosted) (in beta)

- Endpoints
  - [Create an IDV Session](https://docs.mangopay.com/api-reference/idv-sessions/create-idv-session)
  - [View an IDV Session](https://docs.mangopay.com/api-reference/idv-sessions/view-idv-session)
  - [View Checks for an IDV Session](https://mangopay-idv.mintlify.app/api-reference/idv-sessions/view-idv-session-checks)

- Event types
  - `IDENTITY_VERIFICATION_VALIDATED`
  - `IDENTITY_VERIFICATION_FAILED`
  - `IDENTITY_VERIFICATION_INCONCLUSIVE`
  - `IDENTITY_VERIFICATION_OUTDATED`

## [3.28.2] - 2025-02-13
### Updated

#259 Added idempotency key to create conversion methods. Thank you for your contribution [@kaderate](https://github.com/kaderate)!

## [3.28.1] - 2025-02-04
### Updated

Revised tests to improve reliability and address any outdated tests.

## [3.28.0] - 2024-11-15
### Added

New endpoint for [The TWINT PayIn object](https://docs.mangopay.com/api-reference/twint/twint-payin-object#the-twint-payin-object):
- [Create a TWINT PayIn](https://docs.mangopay.com/api-reference/twint/create-twint-payin)
- [View a PayIn (TWINT)](https://docs.mangopay.com/api-reference/twint/view-payin-twint)

New endpoint for [The Swish PayIn object](https://docs.mangopay.com/api-reference/swish/swish-payin-object):
- [Create a Swish PayIn](https://docs.mangopay.com/api-reference/swish/create-swish-payin)
- [View a PayIn (Swish)](https://docs.mangopay.com/api-reference/swish/view-payin-swish)

## [3.27.0] - 2024-10-29
### Added

New endpoints for The Virtual Account object:
- [Create a Virtual Account]()
- [Deactivate a Virtual Account]()
- [View a Virtual Account]()
- [List Virtual Accounts for a Wallet]()
- [View Client Availabilities]()

## [3.26.1] - 2024-10-03
### Fixed

- Updated `RedirectURL` for the [Payconiq PayIn](https://docs.mangopay.com/api-reference/payconiq/payconiq-payin-object#the-payconiq-payin-object)

## [3.26.0] - 2024-08-07
### Added

- New endpoint: [Create a Bancontact PayIn](https://mangopay.com/docs/endpoints/bancontact#create-bancontact-payin)

## [3.25.1] - 2024-04-30
### Fixed

- Updated tests for [Look up metadata for a payment method](https://mangopay.com/docs/endpoints/payment-method-metadata#lookup-payment-method-metadata).

## [3.25.0] - 2024-04-16
### Added

- Add trace header logging : Introduced the `log_trace_headers` boolean configuration key. Set it to true to enable logging of `x_mangopay_trace-id` and `IdempotencyKey` in the log of the http requests.

## [3.24.1] - 2024-04-10
### Fixed

- #249 Improve error handling when logging is enabled
- #226 MultiJson::ParseError is thrown on HTTP error 5XX

## [3.24.0] - 2024-04-02
### Added

- New endpoint [Add tracking to Paypal payin](https://mangopay.com/docs/endpoints/paypal#add-tracking-paypal-payin)

## [3.23.0] - 2024-03-08
### Fixed

- Conversions endpoint spelling

### Added

- The optional Fees parameter is now available on instant conversions, allowing platforms to charge users for FX services. More information [here](https://mangopay.com/docs/release-notes/millefeuille).
- Platforms can now use a quote to secure the rate for a conversion between two currencies for a set amount of time. More information [here](https://mangopay.com/docs/release-notes/millefeuille).
- Introduced the `uk_header_flag` boolean configuration key. Platforms partnered with Mangopay's UK entity should set this key to true for proper configuration.

## [3.22.0] - 2024-02-08
### Added

- New endpoint to look up metadata from BIN or Google Pay token. More information [here](https://mangopay.com/docs/release-notes/kisale)

## [3.21.0] - 2024-01-23
### Added

- The endpoint [View a card Validation](https://mangopay.com/docs/endpoints/card-validations#view-card-validation) is now available

## [3.20.0] - 2023-11-15
### Added

Now, our SDK enables seamless integration with multiple clientIDs, offering enhanced flexibility and customization.

You can effortlessly create multiple configuration objects tailored to your specific needs:

```
config = MangoPay::Configuration.new
config.client_id = 'your-client-id'
config.client_apiKey = 'your-api-key'
config.preproduction = true
```
add them using :

`MangoPay.add_config('config1', config)`

and perform a call with them using :

`MangoPay.get_config('config1').apply_configuration`

The previous method configure() is still working.

## [3.19.0] - 2023-11-02
### Updated

- Giropay and Ideal integrations with Mangopay have been improved.
- Klarna param "MerchantOrderId" has been renamed to "Reference"

## [3.18.0] - 2023-09-29
### Added
- Instantly convert funds between 2 wallets of different currencies owned by the same user with the new SPOT FX endpoints

## [3.17.0] - 2023-09-20
### Added

- A new parameter for Paypal : ShippingPreference
- Klarna is now available as a payment method with Mangopay. This payment method is in private beta. Please contact support if you have any questions.
- #225 It's now possible to configure ssl_options. It's now possible to set to false in preproduction environment. Thanks to @mantaskujalis

## [3.16.0] - 2023-09-04
### Added

- Card validation endpoint management (Private beta)
- New MOPs added : Multibanco, Blik, Satispay (Private beta)

### Fixed

- Execution Type of MB Way and PayPal has been changed from Direct to Web

## [3.15.0] - 2023-07-07
### Added

- Google Pay is now available as a payment method with Mangopay. This payment method is in private beta. Please contact support if you have any questions.
- Paypal integration with Mangopay has been improved. This payment method is in private beta. Please contact support if you have any questions.

### Fixed

- `Phone` parameter instead of `PhoneNumber` for MBWay
- Timeout should be in secondes instead of milliseconds in the configuration
## [3.14.0] - 2023-06-21
### Added

- MB WAY is now available as a payment method with Mangopay. This payment method is in private beta. Please contact support if you have any questions.

## [3.13.2] - 2023-05-18
### Fixes

- fixed GitHub Actions CD pipeline

## [3.13.1] - 2023-05-18
### Fixes

- typo fixed in test context name (@batistadasilva)

## [3.13.0] - 2023-05-17
### Added

- Possibility to configure HTTP `max_retries (http_max_retries)` (default value = 1) and `open_timeout (http_open_timeout)` (default value = 60 seconds)
- Increased default `read_timeout` to 30 seconds


## [3.12.0] - 2022-11-16
### New 30-day preauthorization feature

Preauthorizations can now hold funds for up to 30 days, therefore ensuring the solvency of a registered card for the same amount of time.

- The **Deposit** service has been added with methods for creating, fetching and canceling a deposit
- The **create_pre_authorized_deposit_pay_in** method has been added to the PayIn service

Thanks to 30-day preauthorizations, MANGOPAY can provide a simpler and more flexible payment experience for a wide range of use cases, especially for rentals.

## [3.11.1] - 2022-10-18
### Fixed

Tests has been fixed due to API evolution.

## [3.11.0] - 2022-09-08
##Added
**New country authorizations endpoints**

Country authorizations can now be viewed by using one of the following endpoints:

<a href="https://docs.mangopay.com/endpoints/v2.01/regulatory#e1061_the-country-authorizations-object">View a country's authorizations</a> <br>
<a href="https://docs.mangopay.com/endpoints/v2.01/regulatory#e1061_the-country-authorizations-object">View all countries' authorizations</a>

With these calls, it is possible to check which countries have:

- Blocked user creation
- Blocked bank account creation
- Blocked payout creation

Please refer to the <a href="https://docs.mangopay.com/guide/restrictions-by-country">Restrictions by country</a>
article for more information.

## [3.10.0] - 2022-06-29
##Added
**Recurring: €0 deadlines for CIT**

Setting free recurring payment deadlines is now possible for CIT (customer-initiated transactions) with the **FreeCycles** parameter.

The **FreeCycles** parameter allows platforms to define the number of consecutive deadlines that will be free. The following endpoints have been updated to take into account this new parameter:

<a href="https://docs.mangopay.com/endpoints/v2.01/payins#e1051_create-a-recurring-payin-registration">Create a Recurring PayIn Registration</a><br>
<a href="https://docs.mangopay.com/endpoints/v2.01/payins#e1056_view-a-recurring-payin-registration">View a Recurring PayIn Registration</a><br>

This feature provides new automation capabilities for platforms with offers such as “Get the first month free” or “free trial” subscriptions.

Please refer to the <a href="https://docs.mangopay.com/guide/recurring-payments-introduction">Recurring payments overview</a> documentation for more information.

## [3.9.0] - 2022.03.31
### Added

#### Instant payment eligibility check

With the function
`PayOut::InstantPayoutEligibility::Reachability.create(params)`
the destination bank reachability can now be verified prior to making an instant payout. This results in a better user experience, as this preliminary check will allow the platform to propose the instant payout option only to end users whose bank is eligible.

## [3.8.0] - 2021.10.20
## Added

You can now change the status to "ENDED" for a recurring payment.

## Fixed

- "Status" is now available in the response when you request a recurring payment registration.


## [3.7.0] - 2021.10.11
## Added

### Payconiq

As requested by numerous clients, we are now providing [Payconiq](https://www.payconiq.be) as a new mean-of-payment. To request access, please contact MANGOPAY.

### Flags for KYC documents

**We provide more information regarding refused KYC documents.** Therefore it will be easier for you to adapt your app behavior and help your end user.

You are now able to see the exact explanation thanks to a new parameter called “Flags”.

It has been added to

`$this->_api->KycDocuments->Get($kycDocument->Id);`

It will display one or several error codes that provide the reason(s) why your document validation has failed. These error codes description are available [here](https://docs.mangopay.com/guide/kyc-document).

## Fixed

Idempotency key is not required anymore for UBO declarations

## [3.6.0] - 2021.08.10
## Added

- You can now update and view a Recurring PayIn Registration object. To know more about this feature, please consult the documentation [here](https://docs.mangopay.com/guide/recurring-payments-introduction).
- To improve recurring payments, we have added new parameters for CIT : DebitedFunds & Fees. To know more about this feature, please consult the documentation [here](https://docs.mangopay.com/endpoints/v2.01/payins#e1053_create-a-recurring-payin-cit)

## [3.5.0] - 2021.06.10
## Added

We have added a new feature **[recurring payments](https://docs.mangopay.com/guide/recurring-payments)** dedicated to clients needing to charge a card repeatedly, such as subscriptions or payments installments.

You can start testing in sandbox, to help you define your workflow. This release provides the first elements of the full feature.

- [Create a Recurring PayIn Registration object](https://docs.mangopay.com/endpoints/v2.01/payins#e1051_create-a-recurring-payin-registration), containing all the information to define the recurring payment
- [Initiate your recurring payment flow](https://docs.mangopay.com/endpoints/v2.01/payins#e1053_create-a-recurring-payin-cit) with an authenticated transaction (CIT) using the Card Recurring PayIn endpoint
- [Continue your recurring payment flow](https://docs.mangopay.com/endpoints/v2.01/payins#e1054_create-a-recurring-payin-mit) with an non-authenticated transaction (MIT) using the Card Recurring PayIn endpoint

This feature is not yet available in production and you need to contact the Support team to request access.

## Accepted PRs

- Add support for refund creation
- Allow to fetch UBO Declaration without User ID



## [3.4.0] - 2021.05.27
## Added

### Instant payment

Mangopay introduces the instant payment mode. It allows payouts (transfer from wallet to user bank account) to be processed within 25 seconds, rather than the 48 hours for a standard payout.

You can now use this new type of payout with the Ruby SDK.

Example :

```ruby
bankwire = MangoPay::PayOut::BankWire.get_bankwire(payout['Id'])
# where payout['Id'] is the id of an existing payout
```

Please note that this feature must be authorized and activated by MANGOPAY. More information [here](https://docs.mangopay.com/guide/instant-payment-payout).

### Accepted PRs

- Add support to create refunds for PayIn, Transfer and PayOut transactions.
- ResponseError object improvement

## [3.3.0]
## Fixed

### IBAN for testing purposes

⚠️ **IBAN provided for testing purpose should never be used outside of a testing environement!**

More information about how to test payments, click [here](https://docs.mangopay.com/guide/testing-payments).

### Others

- Adding missing json require in log requests filter spec. Thank you @Vin0uz
- Extend fetch_wallet and create_payout API. Thank you @peterb

## Added

Some of you use a lot the [PreAuthorization](https://docs.mangopay.com/endpoints/v2.01/preauthorizations#e183_the-preauthorization-object) feature of our API. To make your life easier, we have added three new events :

- PREAUTHORIZATION_CREATED
- PREAUTHORIZATION_SUCCEEDED
- PREAUTHORIZATION_FAILED

The goal is to help you monitor a PreAuthorization with a [webhook](https://docs.mangopay.com/endpoints/v2.01/hooks#e246_the-hook-object).

*Example: If a PreAuthorization is desynchronized, when the status is updated, you will be able to know it.*



## [3.2.0]
## Added

### On demand feature for 3DSv2

> **This on-demand feature is for testing purposes only and will not be available in production**

#### Request

We've added a new parameter `Requested3DSVersion` (not mandatory) that allows you to choose between versions of 3DS protocols (managed by the parameter `SecureMode`). Two values are available:
* `V1`
* `V2_1`

If nothing is sent, the flow will be 3DS V1.

The `Requested3DSVersion` may be included on all calls to the following endpoints:
* `/preauthorizations/card/direct`
* `/payins/card/direct`

#### Response

In the API response, the `Requested3DSVersion` will show the value you requested:
* `V1`
* `V2_1`
* `null` – indicates that nothing was requested

The parameter `Applied3DSVersion` shows you the version of the 3DS protocol used. Two values are possible:
* `V1`
* `V2_1`




## [3.1.0]
- 3DS2 integration with Shipping and Billing objects, including FirstName and LastName fields
  The objects Billing and Shipping may be included on all calls to the following endpoints:
  - /preauthorizations/card/direct
  - /payins/card/direct
  - /payins/card/web
- Enable Instant Payment for payouts by adding a new parameter PayoutModeRequested on the following endpoint /payouts/bankwire
  - The new parameter PayoutModeRequested can take two differents values : "INSTANT_PAYMENT" or "STANDARD" (STANDARD = the way we procede normaly a payout request)
  - This new parameter is not mandatory and if empty or not present, the payout will be "STANDARD" by default
  - Instant Payment is in beta all over Europe - SEPA region
- Add test on new payout mode PayoutModeRequested
## [3.0.37] - 2020-10-30
- Card Validation endpoint fully activated
- added pre authorizations transactions method
- added new methods for client bank accounts and payouts
- Send headers for different api calls

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


 