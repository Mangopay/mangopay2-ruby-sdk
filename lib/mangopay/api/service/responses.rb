require_relative '../uri_provider'
require_relative '../../model/response_replica'

module MangoApi

  # Provides API method delegates for replicating
  # responses based on idempotency keys.
  module Responses
    class << self
      include UriProvider

      # Retrieves the response of a previous request by
      # the idempotency key which was provided at the time.
      #
      # @param +id_key+ Idempotency key provided with the original request
      # @return [ResponseReplica] Replica of the original response
      def replicate(id_key)
        uri = provide_uri(:replicate_response, id_key)
        response = HttpClient.get uri
        parse response
      end

      private

      # Parses the received response into a corresponding object
      #
      # @param +response+ [Hash] hashed response
      # @return [ResponseReplica] De-serialized typed response replication
      def parse(response)
        replica = MangoModel::ResponseReplica.new.dejsonify response
        type = entity_type(replica.resource, replica.request_url)
        replica.resource = type.new.dejsonify replica.resource if type
        replica
      end

      # Asserts the effective type of entity returned
      # in an API response, based on the request URL.
      #
      # @param +hash+ [Hash] hashed JSON response
      # @param +source_url+ [String] URL from where the entity was returned
      # @return [Class] actual type of the entity
      def entity_type(hash, source_url)
        case source_url
        when %r{/reports}
          MangoModel::Report
        when %r{(/settlementtransfer|/settlements)}
          MangoModel::SettlementTransfer
        when %r{/repudiations}
          MangoModel::Repudiation
        when %r{(/disputes.+/documents|dispute-documents)}
          MangoModel::DisputeDocument
        when %r{/disputes}
          MangoModel::Dispute
        when %r{(/kyc/documents.+/consult|/dispute-documents.+/consult)}
          MangoModel::DocumentPageConsult
        when %r{/refunds}
          MangoModel::Refund
        when %r{/events}
          MangoModel::Event
        when %r{/hooks}
          MangoModel::Hook
        when %r{/ubodeclarations}
          MangoModel::UboDeclaration
        when %r{/kyc/documents}
          MangoModel::KycDocument
        when %r{/payouts/}
          MangoModel::PayOut
        when %r{/extended/}
          MangoModel::PayInWebExtendedView
        when %r{/mandates}
          MangoModel:: Mandate
        when %r{/transactions}
          MangoModel::Transaction
        when %r{/preauthorizations}
          MangoModel::PreAuthorization
        when %r{/cards}
          MangoModel::Card
        when %r{/cardregistrations}
          MangoModel::CardRegistration
        when %r{/payins}
          MangoModel.pay_in_type(hash)
        when %r{/transfers}
          MangoModel::Transfer
        when %r{/emoney}
          MangoModel::EMoney
        when %r{/bankaccounts}
          MangoModel.bank_account_type(hash)
        when %r{/clients/wallets}
          MangoModel::ClientWallet
        when %r{/wallets}
          MangoModel::Wallet
        when %r{/users}
          MangoModel.user_type(hash)
        when %r{/clients}
          MangoModel::Client
        else
          raise 'Could not assert effective type for entity source: ' + source_url
        end
      end
    end
  end
end