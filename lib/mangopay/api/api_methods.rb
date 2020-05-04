require 'forwardable'

module MangoApi

  # Declares API method URLs.
  class ApiMethods
    class << self
      extend Forwardable

      @hash = {
          create_token: %w[POST oauth/token],

          create_user: %w[POST %(users/#{_params[0].person_type.to_s.downcase})],
          update_user: %w[PUT %(users/#{_params[0]}/#{_params[1]})],
          get_user: %w[GET %(users/#{_params[0]})],
          get_users: %w[GET users],

          create_account: %w[POST %(users/#{_params[0].user_id}/bankaccounts/#{_params[0].type.to_s.downcase})],
          deactivate_account: %w[PUT %(users/#{_params[0]}/bankaccounts/#{_params[1]})],
          get_account: %w[GET %(users/#{_params[0]}/bankaccounts/#{_params[1]})],
          get_accounts: %w[GET %(users/#{_params[0]}/bankaccounts)],

          create_wallet: %w[POST wallets],
          update_wallet: %w[PUT %(wallets/#{_params[0].id})],
          get_wallet: %w[GET %(wallets/#{_params[0]})],
          get_users_wallets: %w[GET %(users/#{_params[0]}/wallets)],

          update_client: %w[PUT clients],
          get_client: %w[GET clients],
          upload_client_logo: %w[PUT clients/logo],

          get_client_wallet: %w[GET %(clients/wallets/#{_params[0].to_s}/#{_params[1].to_s})],
          get_client_wallets: %w[GET clients/wallets],
          get_client_wallets_funds_type: %w[GET %(clients/wallets/#{_params[0].to_s})],

          get_users_e_money_year: %w[GET %(users/#{_params[0]}/emoney/#{_params[1]})],
          get_users_e_money_month: %w[GET %(users/#{_params[0]}/emoney/#{_params[1]}/#{_params[2]})],

          create_transfer: %w[POST transfers],
          get_transfer: %w[POST %(transfers/#{_params[0]})],

          create_card_web_pay_in: %w[POST payins/card/web],
          create_card_direct_pay_in: %w[POST payins/card/direct],
          create_card_pre_authorized_pay_in: %w[POST payins/preauthorized/direct],
          create_bank_wire_direct_pay_in: %w[POST payins/bankwire/direct],
          create_client_bank_wire_direct_pay_in: %w[POST clients/payins/bankwire/direct],
          create_direct_debit_web_pay_in: %w[POST payins/directdebit/web],
          create_direct_debit_direct_pay_in: %w[POST payins/directdebit/direct],
          create_paypal_web_pay_in: %w[POST payins/paypal/web],
          create_apple_pay_pay_in: %w[POST payins/applepay/direct],
          create_google_pay_pay_in: %[POST payins/googlepay/direct],
          get_pay_in: %w[GET %(payins/#{_params[0]})],
          get_payins_refunds: %w[GET %(payins/#{_params[0]}/refunds)],

          get_extended_card_view: %w[GET %(payins/card/web/#{_params[0]}/extended)],

          create_card_registration: %w[POST cardregistrations],
          complete_card_registration: %w[PUT %(cardregistrations/#{_params[0]})],
          get_card_registration: %w[GET %(cardregistrations/#{_params[0]})],

          get_card: %w[GET %(cards/#{_params[0]})],
          get_users_cards: %w[GET %(users/#{_params[0]}/cards)],
          get_cards_by_fingerprint: %w[GET %(cards/fingerprints/#{_params[0]})],
          deactivate_card: %w[PUT %(cards/#{_params[0]})],
          get_preauthorizations_for_card: %w[GET %(cards/#{_params[0]}/preauthorizations)],

          get_users_transactions: %w[GET %(users/#{_params[0]}/transactions)],
          get_wallets_transactions: %w[GET %(wallets/#{_params[0]}/transactions)],
          get_disputes_transactions: %w[GET %(disputes/#{_params[0]}/transactions)],
          get_clients_transactions: %w[GET %(clients/transactions)],
          get_client_wallets_transactions: %w[GET %(clients/wallets/#{_params[0].to_s}/#{_params[1].to_s}/transactions)],
          get_pre_authorizations_transactions: %w[GET %(preauthorizations/#{_params[0]}/transactions)],
          get_cards_transactions: %w[GET %(cards/#{_params[0]}/transactions)],
          get_bank_accounts_transactions: %w[GET %(bankaccounts/#{_params[0]}/transactions)],
          get_mandates_transactions: %w[GET %(mandates/#{_params[0]}/transactions)],

          create_pre_authorization: %w[POST preauthorizations/card/direct],
          get_pre_authorization: %w[GET %(preauthorizations/#{_params[0]})],
          cancel_pre_authorization: %w[PUT %(preauthorizations/#{_params[0]})],
          get_users_pre_authorizations: %w[GET %(users/#{_params[0]}/preauthorizations)],

          create_mandate: %w[POST mandates/directdebit/web],
          get_mandate: %w[GET %(mandates/#{_params[0]})],
          cancel_mandate: %w[PUT %(mandates/#{_params[0]}/cancel)],
          get_mandates: %w[GET mandates],
          get_users_mandates: %w[GET %(users/#{_params[0]}/mandates)],
          get_accounts_mandates: %w[GET %(users/#{_params[0]}/bankaccounts/#{_params[1]}/mandates)],

          create_pay_out: %w[POST payouts/bankwire],
          get_pay_out: %w[GET %(payouts/#{_params[0]})],

          create_kyc_document: %w[POST %(users/#{_params[0]}/kyc/documents)],
          upload_kyc_document_page: %w[POST %(users/#{_params[0]}/kyc/documents/#{_params[1]}/pages)],
          submit_kyc_document: %w[PUT %(users/#{_params[0]}/kyc/documents/#{_params[1]})],
          get_users_kyc_documents: %w[GET %(users/#{_params[0]}/kyc/documents)],
          get_kyc_documents: %w[GET kyc/documents],
          consult_kyc_document: %w[POST %(kyc/documents/#{_params[0]}/consult)],

          all_ubo_declaration: %w[GET %(users/#{_params[0]}/kyc/ubodeclarations)],
          create_ubo_declaration: %w[POST %(users/#{_params[0]}/kyc/ubodeclarations)],
          get_ubo_declaration: %w[GET %(users/#{_params[0]}/kyc/ubodeclarations/#{_params[1]})],
          get_ubo_declaration_by_id: %w[GET %(kyc/ubodeclarations/#{_params[0]})],
          submit_ubo_declaration: %w[PUT %(users/#{_params[0]}/kyc/ubodeclarations/#{_params[1]})],

          create_ubo: %w[POST %(users/#{_params[0]}/kyc/ubodeclarations/#{_params[1]}/ubos)],
          update_ubo: %w[PUT %(users/#{_params[0]}/kyc/ubodeclarations/#{_params[1]}/ubos/#{_params[2]})],
          get_ubo: %w[GET %(users/#{_params[0]}/kyc/ubodeclarations/#{_params[1]}/ubos/#{_params[2]})],

          create_hook: %w[POST hooks],
          update_hook: %w[PUT %(hooks/#{_params[0]})],
          get_hook: %w[GET %(hooks/#{_params[0]})],
          get_hooks: %w[GET hooks],

          get_events: %w[GET events],

          create_pay_in_refund: %w[POST %(payins/#{_params[0]}/refunds)],
          create_transfer_refund: %w[POST %(transfers/#{_params[0]}/refunds)],
          get_payouts_refunds: %w[GET %(payouts/#{_params[0]}/refunds)],
          get_transfers_refunds: %w[GET %(transfers/#{_params[0]}/refunds)],

          update_dispute: %w[PUT %(disputes/#{_params[0]})],
          close_dispute: %w[PUT %(disputes/#{_params[0]}/close)],
          submit_dispute: %w[PUT %(disputes/#{_params[0]}/submit)],
          resubmit_dispute: %w[PUT %(disputes/#{_params[0]}/submit)],
          get_dispute: %w[GET %(disputes/#{_params[0]})],
          get_users_disputes: %w[GET %(users/#{_params[0]}/disputes)],
          get_wallets_disputes: %w[GET %(wallets/#{_params[0]}/disputes)],
          get_disputes_pending_settlement: %w[GET disputes/pendingsettlement],
          get_disputes: %w[GET disputes],

          create_dispute_document: %w[POST %(disputes/#{_params[0]}/documents)],
          upload_dispute_document_page: %w[POST %(disputes/#{_params[0]}/documents/#{_params[1]}/pages)],
          submit_dispute_document: %w[PUT %(disputes/#{_params[0]}/documents/#{_params[1]})],
          get_dispute_document: %w[GET %(dispute-documents/#{_params[0]})],
          get_disputes_documents: %w[GET %(disputes/#{_params[0]}/documents)],
          get_dispute_documents: %w[GET dispute-documents],
          consult_dispute_document: %w[POST %(dispute-documents/#{_params[0]}/consult)],

          get_repudiation: %w[GET %(repudiations/#{_params[0]})],
          get_repudiations_refunds: %w[GET %(repudiations/#{_params[0]}/refunds)],

          create_settlement_transfer: %w[POST %(repudiations/#{_params[0]}/settlementtransfer)],
          get_settlement_transfer: %w[GET %(settlements/#{_params[0]})],

          create_transaction_report: %w[POST reports/transactions],
          create_wallet_report: %w[POST reports/wallets],
          get_report: %w[GET %(reports/#{_params[0]})],
          get_reports: %w[GET reports],

          replicate_response: %w[GET %(responses/#{_params[0]})]
      }

      def_delegators @hash, :[]
    end
  end
end