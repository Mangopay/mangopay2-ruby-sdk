require 'json'
require_relative 'read_only_fields'
require_relative '../common/json_tag_converter'
require_relative 'log_provider'
require_relative '../model/model'
require_relative '../model/entity/account/bank_account'

module MangoPay

  # To be included in order to apply JSON de/serialization methods
  module Jsonifier
    # require here to satisfy circular dependency
    require_relative '../model/entity/card_registration'
    require_relative '../model/entity/pre_authorization'
    require_relative '../model/entity/account/iban_bank_account'
    require_relative '../model/entity/account/us_bank_account'
    require_relative '../model/entity/account/ca_bank_account'
    require_relative '../model/entity/account/gb_bank_account'
    require_relative '../model/entity/account/other_bank_account'
    require_relative '../model/entity/mandate'
    require_relative '../model/entity/kyc_document'
    require_relative '../model/entity/pay_in/pay_in'
    require_relative '../model/entity/pay_in/apple_pay_direct_pay_in'
    require_relative '../model/entity/pay_out'
    require_relative '../model/entity/ubo_declaration'
    require_relative '../model/entity/hook'
    require_relative '../model/entity/dispute'
    require_relative '../model/entity/dispute_document'
    require_relative '../model/entity/report'
    require_relative '../model/declared_ubo'
    LOG = LogProvider.provide(self)

    # Serializes an object to a JSON string.
    # Read-only fields will be removed
    #
    # @return [String] JSON string of non-read-only fields and values
    def jsonify!
      json = hashed_variables.to_json
      # hash.to_json() sometimes adds
      # unnecessary backslashes and double quotes
      json.delete!('\\')
      json.gsub!(/"{/, '{')
      json.gsub!(/}"/, '}')
      LOG.debug 'JSONIFIED {}', inspect
      LOG.debug 'INTO {}', json
      json
    end

    # De-serializes an object from a JSON-originating hash.
    #
    # @param +hash+ [Hash] hash converted from an API-returned JSON string
    # @return [Object] corresponding object (typed)
    def dejsonify(hash)
      return nil unless hash
      hash.each do |tag, value|
        field = JsonTagConverter.from_json_tag tag
        field_value = nil
        if field == 'type'
          if is_a? MangoModel::BankAccount
            field_value = MangoModel::AccountType.value_of value
          elsif is_a? MangoModel::KycDocument
            field_value = MangoModel::KycDocumentType.value_of value
          elsif is_a? MangoModel::DisputeDocument
            field_value = MangoModel::DisputeDocumentType.value_of value
          end
        end
        if field == 'status'
          if is_a? MangoModel::CardRegistration
            field_value = MangoModel::CardStatus.value_of value
          elsif is_a? MangoModel::PreAuthorization
            field_value = MangoModel::PreAuthorizationStatus.value_of value
          elsif is_a?(MangoModel::KycDocument) || is_a?(MangoModel::DisputeDocument)
            field_value = MangoModel::DocumentStatus.value_of value
          elsif is_a? MangoModel::UboDeclaration
            field_value = MangoModel::UboDeclarationStatus.value_of value
          elsif is_a? MangoModel::DeclaredUbo
            field_value = MangoModel::DeclaredUboStatus.value_of value
          elsif is_a? MangoModel::Hook
            field_value = MangoModel::HookStatus.value_of value
          elsif is_a? MangoModel::Dispute
            field_value = MangoModel::DisputeStatus.value_of value
          elsif is_a? MangoModel::Report
            field_value = MangoModel::ReportStatus.value_of value
          end
        end
        if is_a? MangoModel::Mandate
          if field == 'culture'
            field_value = MangoModel::MandateCultureCode.value_of value
          elsif field == 'status'
            field_value = MangoModel::MandateStatus.value_of value
          elsif field == 'execution_type'
            field_value = MangoModel::MandateExecutionType.value_of value
          end
        end
        if field == 'execution_type' && is_a?(MangoModel::PreAuthorization)
          field_value = MangoModel::PreAuthorizationExecutionType.value_of value
        end
        if field == 'payment_type' && is_a?(MangoModel::PayOut)
          field_value = MangoModel::PayOutPaymentType.value_of value
        end
        if field == 'refused_reason_type'
          if is_a? MangoModel::DeclaredUbo
            field_value = MangoModel::DeclaredUboRefusedReasonType.value_of value
          elsif is_a? MangoModel::DisputeDocument
            field_value = MangoModel::DisputeDocRefusedReasonType.value_of value
          end
        end
        if field == 'validity' && is_a?(MangoModel::Hook)
          field_value = MangoModel::HookValidity.value_of value
        end
        if field == 'date' && is_a?(MangoModel::Event)
          field_value = value
        end
        if field == 'declared_ubos' && is_a?(MangoModel::UboDeclaration)
          field_value = []
          value.each do |declared_ubo|
            field_value << MangoModel::DeclaredUbo.new.dejsonify(declared_ubo)
          end
        end
        if field == 'bank_account' && is_a?(MangoModel::BankWireDirectPayIn)
          field_value = case value['Type']
                        when MangoModel::AccountType::IBAN.to_s
                          MangoModel::IbanBankAccount.new.dejsonify value
                        when MangoModel::AccountType::US.to_s
                          MangoModel::UsBankAccount.new.dejsonify value
                        when MangoModel::AccountType::CA.to_s
                          MangoModel::CaBankAccount.new.dejsonify value
                        when MangoModel::AccountType::GB.to_s
                          MangoModel::GbBankAccount.new.dejsonify value
                        when MangoModel::AccountType::OTHER.to_s
                          MangoModel::OtherBankAccount.new.dejsonify value
                        else
                          raise 'Unrecognized bank account type: ' + value['Type']
                        end
        end
        field_value ||= case field
                        when *MangoModel.fields_of_type(MangoModel::Address)
                          MangoModel::Address.new.dejsonify value
                        when *MangoModel.fields_of_type(MangoModel::Money)
                          MangoModel::Money.new.dejsonify value
                        when *MangoModel.fields_of_type(MangoModel::RefundReason)
                          MangoModel::RefundReason.new.dejsonify value
                        when *MangoModel.fields_of_type(MangoModel::DisputeReason)
                          MangoModel::DisputeReason.new.dejsonify value
                        when *MangoModel.fields_of_type(MangoModel::PlatformCategorization)
                          MangoModel::PlatformCategorization.new.dejsonify value
                        when *MangoModel.fields_of_type(MangoModel::Billing)
                          MangoModel::Billing.new.dejsonify value
                        when *MangoModel.fields_of_type(MangoModel::SecurityInfo)
                          MangoModel::SecurityInfo.new.dejsonify value
                        when *MangoModel.fields_of_type(MangoModel::PersonType)
                          MangoModel::PersonType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::KycLevel)
                          MangoModel::KycLevel.value_of value
                        when *MangoModel.fields_of_type(MangoModel::LegalPersonType)
                          MangoModel::LegalPersonType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::CountryIso)
                          MangoModel::CountryIso.value_of value
                        when *MangoModel.fields_of_type(MangoModel::DepositType)
                          MangoModel::DepositType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::CurrencyIso)
                          MangoModel::CurrencyIso.value_of value
                        when *MangoModel.fields_of_type(MangoModel::FundsType)
                          MangoModel::FundsType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::PlatformType)
                          MangoModel::PlatformType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::TransactionType)
                          MangoModel::TransactionType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::TransactionNature)
                          MangoModel::TransactionNature.value_of value
                        when *MangoModel.fields_of_type(MangoModel::TransactionStatus)
                          MangoModel::TransactionStatus.value_of value
                        when *MangoModel.fields_of_type(MangoModel::PayInPaymentType)
                          MangoModel::PayInPaymentType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::PayInExecutionType)
                          MangoModel::PayInExecutionType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::CardType)
                          MangoModel::CardType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::SecureMode)
                          MangoModel::SecureMode.value_of value
                        when *MangoModel.fields_of_type(MangoModel::CultureCode)
                          MangoModel::CultureCode.value_of value
                        when *MangoModel.fields_of_type(MangoModel::CardValidity)
                          MangoModel::CardValidity.value_of value
                        when *MangoModel.fields_of_type(MangoModel::PaymentStatus)
                          MangoModel::PaymentStatus.value_of value
                        when *MangoModel.fields_of_type(MangoModel::DirectDebitType)
                          MangoModel::DirectDebitType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::MandateScheme)
                          MangoModel::MandateScheme.value_of value
                        when *MangoModel.fields_of_type(MangoModel::MandateType)
                          MangoModel::MandateType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::KycDocRefusedReasonType)
                          MangoModel::KycDocRefusedReasonType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::NaturalUserCapacity)
                          MangoModel::NaturalUserCapacity.value_of value
                        when *MangoModel.fields_of_type(MangoModel::EventType)
                          MangoModel::EventType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::RefundReasonType)
                          MangoModel::RefundReasonType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::DisputeType)
                          MangoModel::DisputeType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::DisputeReasonType)
                          MangoModel::DisputeReasonType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::DisputeStatus)
                          MangoModel::DisputeStatus.value_of value
                        when *MangoModel.fields_of_type(MangoModel::DownloadFormat)
                          MangoModel::DownloadFormat.value_of value
                        when *MangoModel.fields_of_type(MangoModel::ReportType)
                          MangoModel::ReportType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::BusinessType)
                          MangoModel::BusinessType.value_of value
                        when *MangoModel.fields_of_type(MangoModel::Sector)
                          MangoModel::Sector.value_of value
                        when *MangoModel.fields_of_type(MangoModel::AvsResult)
                          MangoModel::AvsResult.value_of value
                        when *MangoModel.fields_of_type(DateTime)
                          DateTime.parse value
                        else
                          value
                        end
        instance_variable_set "@#{field}", field_value
      end
      LOG.debug 'DE-JSONIFIED {}', hash
      LOG.debug 'INTO {}', inspect
      self
    end

    private

    # Prepares a hash mapping API-standard
    # instance variable names to their JSON values.
    # Removes any of the fields which are considered
    # read-only by the API
    def hashed_variables
      hash = {}
      instance_variables.each do |var|
        key = JsonTagConverter.to_json_tag var.to_s[1..-1]
        value = json_value_for var
        hash[key] = value
      end
      ReadOnlyFields.remove_from! hash
      hash
    end

    # Converts the value in a specified instance variable
    # to its JSON representation.
    def json_value_for(var_name)
      var_value = instance_variable_get var_name
      begin
        if var_value.singleton_class.included_modules.include? Jsonifier
          var_value.jsonify!
        else
          var_value
        end
      rescue TypeError
        # raised by .singleton_class() when called on primitives
        var_value
      end
    end
  end
end