require 'forwardable'

module MangoApi

  # Declares API method URLs.
  class ApiMethods
    class << self
      extend Forwardable

      @hash = {
        create_token: %w[POST oauth/token],

        create_user: %w[POST %(users/#{_param1.person_type.to_s.downcase})],
        update_user: %w[PUT %(users/#{_param1}/#{_param2})],
        get_user: %w[GET %(users/#{_param1})],
        get_users: %w[GET users],

        create_account: %w[POST %(users/#{_param1.user_id}/bankaccounts/#{_param1.type.to_s.downcase})],
        deactivate_account: %w[PUT %(users/#{_param1}/bankaccounts/#{_param2})],
        get_account: %w[GET %(users/#{_param1}/bankaccounts/#{_param2})],
        get_accounts: %w[GET %(users/#{_param1}/bankaccounts)],

        create_wallet: %w[POST wallets],
        update_wallet: %w[PUT %(wallets/#{_param1.id})],
        get_wallet: %w[GET %(wallets/#{_param1})],
        get_users_wallets: %w[GET %(users/#{_param1}/wallets)],

        update_client: %w[PUT clients],
        get_client: %w[GET clients],
        upload_client_logo: %w[PUT clients/logo],

        get_client_wallet: %w[GET %(clients/wallets/#{_param1.to_s}/#{_param2.to_s})],
        get_client_wallets: %w[GET clients/wallets],
        get_client_wallets_funds_type: %w[GET %(clients/wallets/#{_param1.to_s})],

        get_users_e_money: %w[GET %(users/#{_param1}/emoney)],

        create_transfer: %w[POST transfers],
        get_transfer: %w[POST %(transfers/#{_param1})],

        create_card_web_pay_in: %w[POST payins/card/web],
        create_card_direct_pay_in: %w[POST payins/card/direct],
        create_card_pre_authorized_pay_in: %w[POST payins/preauthorized/direct],
        create_bank_wire_direct_pay_in: %w[POST payins/bankwire/direct],
        create_client_bank_wire_direct_pay_in: %w[POST clients/payins/bankwire/direct],
        create_direct_debit_web_pay_in: %w[POST payins/directdebit/web],
        create_direct_debit_direct_pay_in: %w[POST payins/directdebit/direct],
        get_pay_in: %w[GET %(payins/#{_param1})],
        get_payins_refunds: %w[GET %(payins/#{_param1}/refunds)],

        get_extended_card_view: %w[GET %(payins/card/web/#{_param1}/extended)],

        create_card_registration: %w[POST cardregistrations],
        complete_card_registration: %w[PUT %(cardregistrations/#{_param1})],
        get_card_registration: %w[GET %(cardregistrations/#{_param1})],

        get_card: %w[GET %(cards/#{_param1})],
        get_users_cards: %w[GET %(users/#{_param1}/cards)],
        get_cards_by_fingerprint: %w[GET %(cards/fingerprints/#{_param1})],
        deactivate_card: %w[PUT %(cards/#{_param1})],
        get_preauthorizations_for_card: %w[GET %(cards/#{_param1}/preauthorizations)],

        get_users_transactions: %w[GET %(users/#{_param1}/transactions)],
        get_wallets_transactions: %w[GET %(wallets/#{_param1}/transactions)],
        get_disputes_transactions: %w[GET %(disputes/#{_param1}/transactions)],
        get_clients_transactions: %w[GET %(clients/transactions)],
        get_client_wallets_transactions: %w[GET %(clients/wallets/#{_param1.to_s}/#{_param2.to_s}/transactions)],
        get_pre_authorizations_transactions: %w[GET %(preauthorizations/#{_param1}/transactions)],
        get_bank_accounts_transactions: %w[GET %(bankaccounts/#{_param1}/transactions)],

        create_pre_authorization: %w[POST preauthorizations/card/direct],
        get_pre_authorization: %w[GET %(preauthorizations/#{_param1})],
        cancel_pre_authorization: %w[PUT %(preauthorizations/#{_param1})],
        get_users_pre_authorizations: %w[GET %(users/#{_param1}/preauthorizations)],

        create_mandate: %w[POST mandates/directdebit/web],
        get_mandate: %w[GET %(mandates/#{_param1})],
        cancel_mandate: %w[PUT %(mandates/#{_param1}/cancel)],
        get_mandates: %w[GET mandates],
        get_users_mandates: %w[GET %(users/#{_param1}/mandates)],
        get_accounts_mandates: %w[GET %(users/#{_param1}/bankaccounts/#{_param2}/mandates)],

        create_pay_out: %w[POST payouts/bankwire],
        get_pay_out: %w[GET %(payouts/#{_param1})],

        create_kyc_document: %w[POST %(users/#{_param1}/kyc/documents)],
        upload_kyc_document_page: %w[POST %(users/#{_param1}/kyc/documents/#{_param2}/pages)],
        submit_kyc_document: %w[PUT %(users/#{_param1}/kyc/documents/#{_param2})],
        get_users_kyc_documents: %w[GET %(users/#{_param1}/kyc/documents)],
        get_kyc_documents: %w[GET kyc/documents],
        consult_kyc_document: %w[POST %(kyc/documents/#{_param1}/consult)],

        create_ubo_declaration: %w[POST %(users/legal/#{_param1}/ubodeclarations)],
        update_ubo_declaration: %w[PUT %(ubodeclarations/#{_param1})],
        submit_ubo_declaration: %w[PUT %(ubodeclarations/#{_param1})],

        create_hook: %w[POST hooks],
        update_hook: %w[PUT %(hooks/#{_param1})],
        get_hook: %w[GET %(hooks/#{_param1})],
        get_hooks: %w[GET hooks],

        get_events: %w[GET events],

        create_pay_in_refund: %w[POST %(payins/#{_param1}/refunds)],
        create_transfer_refund: %w[POST %(transfers/#{_param1}/refunds)],
        get_payouts_refunds: %w[GET %(payouts/#{_param1}/refunds)],
        get_transfers_refunds: %w[GET %(transfers/#{_param1}/refunds)],

        update_dispute: %w[PUT %(disputes/#{_param1})],
        close_dispute: %w[PUT %(disputes/#{_param1}/close)],
        submit_dispute: %w[PUT %(disputes/#{_param1}/submit)],
        resubmit_dispute: %w[PUT %(disputes/#{_param1}/submit)],
        get_dispute: %w[GET %(disputes/#{_param1})],
        get_users_disputes: %w[GET %(users/#{_param1}/disputes)],
        get_wallets_disputes: %w[GET %(wallets/#{_param1}/disputes)],
        get_disputes_pending_settlement: %w[GET disputes/pendingsettlement],
        get_disputes: %w[GET disputes],

        create_dispute_document: %w[POST %(disputes/#{_param1}/documents)],
        upload_dispute_document_page: %w[POST %(disputes/#{_param1}/documents/#{_param2}/pages)],
        submit_dispute_document: %w[PUT %(disputes/#{_param1}/documents/#{_param2})],
        get_dispute_document: %w[GET %(dispute-documents/#{_param1})],
        get_disputes_documents: %w[GET %(disputes/#{_param1}/documents)],
        get_dispute_documents: %w[GET dispute-documents],
        consult_dispute_document: %w[POST %(dispute-documents/#{_param1}/consult)],

        get_repudiation: %w[GET %(repudiations/#{_param1})],
        get_repudiations_refunds: %w[GET %(repudiations/#{_param1}/refunds)],

        create_settlement_transfer: %w[POST %(repudiations/#{_param1}/settlementtransfer)],
        get_settlement_transfer: %w[GET %(settlements/#{_param1})],

        create_transaction_report: %w[POST reports/transactions],
        create_wallet_report: %w[POST reports/wallets],
        get_report: %w[GET %(reports/#{_param1})],
        get_reports: %w[GET reports],

        replicate_response: %w[GET %(responses/#{_param1})]
      }

      def_delegators @hash, :[]
    end
  end
end