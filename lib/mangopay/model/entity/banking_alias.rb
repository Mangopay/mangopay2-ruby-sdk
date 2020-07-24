require_relative '../../common/jsonifier'

module MangoModel

  # Mandate entity
  class BankingAlias < EntityBase
    include MangoPay::Jsonifier

    # [String] The user ID who was credited
    attr_accessor :credited_user_id

    # [String] The Id of wallet
    attr_accessor :wallet_id

    # [BankingAliasType] The type of banking alias
    attr_accessor :type

    # [String] Owner name
    attr_accessor :owner_name

    # [Boolean] Whether the banking alias is active or not
    attr_accessor :active

    # [CountryIso] Its country
    attr_accessor :country
  end
end