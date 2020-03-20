require_relative '../../spec/context/pay_in_context'
require_relative '../../lib/mangopay/api/service/pay_ins'

describe MangoApi::PayIns do
  include_context 'pay_in_context'

  describe '.create' do

    describe '#CARD WEB' do
      context 'given a valid object' do
        pay_in = CARD_WEB_PAY_IN_DATA

        it 'creates the card web pay-in entity' do
          created = MangoApi::PayIns.create_card_web pay_in

          expect(created).to be_kind_of MangoModel::CardWebPayIn
          expect(created.id).not_to be_nil
          expect(created.status).to be MangoModel::TransactionStatus::CREATED
          expect(created.payment_type).to be MangoModel::PayInPaymentType::CARD
          expect(created.execution_type).to be MangoModel::PayInExecutionType::WEB
          expect(its_the_same_card_web(pay_in, created)).to be_truthy
        end
      end
    end

    describe '#CARD DIRECT' do
      context 'given a valid object' do
        pay_in = CARD_DIRECT_PAY_IN_DATA

        it 'creates the card direct pay-in entity' do
          created = MangoApi::PayIns.create_card_direct pay_in

          expect(created).to be_kind_of MangoModel::CardDirectPayIn
          expect(created.id).not_to be_nil
          expect(created.status).to be MangoModel::TransactionStatus::SUCCEEDED
          expect(created.payment_type).to be MangoModel::PayInPaymentType::CARD
          expect(created.execution_type).to be MangoModel::PayInExecutionType::DIRECT
          expect(created.security_info.avs_result).to be MangoModel::AvsResult::NO_CHECK
          expect(its_the_same_card_direct(pay_in, created)).to be_truthy
        end
      end
    end

    describe '#CARD PREAUTHORIZED' do
      context 'given a valid object' do
        pay_in = CARD_PRE_AUTH_PAY_IN_DATA

        it 'creates the card pre-authorized pay-in entity' do
          created = CARD_PRE_AUTH_PAY_IN_PERSISTED

          expect(created).to be_kind_of MangoModel::CardPreAuthorizedPayIn
          expect(created.id).not_to be_nil
          expect(created.status).to be MangoModel::TransactionStatus::SUCCEEDED
          expect(created.payment_type).to be MangoModel::PayInPaymentType::PREAUTHORIZED
          expect(created.execution_type).to be MangoModel::PayInExecutionType::DIRECT
          expect(its_the_same_card_pre_auth(pay_in, created)).to be_truthy
        end
      end
    end

    describe '#BANK_WIRE DIRECT' do

      context 'to a wallet' do
        context 'given a valid object' do
          pay_in = BANK_WIRE_DIRECT_PAY_IN_DATA

          it 'creates the bank wire direct pay-in entity' do
            created = MangoApi::PayIns.create_bank_wire_direct pay_in

            expect(created).to be_kind_of MangoModel::BankWireDirectPayIn
            expect(created.id).not_to be_nil
            expect(created.status).to be MangoModel::TransactionStatus::CREATED
            expect(created.payment_type).to be MangoModel::PayInPaymentType::BANK_WIRE
            expect(created.execution_type).to be MangoModel::PayInExecutionType::DIRECT
            expect(created.bank_account).to be_kind_of MangoModel::BankAccount
            expect(its_the_same_bank_wire_direct(pay_in, created)).to be_truthy
          end
        end
      end

      context 'to a client wallet' do
        pay_in = MangoModel::BankWireDirectPayIn.new
        pay_in.credited_wallet_id = 'CREDIT_EUR'
        pay_in.declared_debited_funds = MangoModel::Money.new
        pay_in.declared_debited_funds.currency = MangoModel::CurrencyIso::EUR
        pay_in.declared_debited_funds.amount = 120
        pay_in.declared_fees = MangoModel::Money.new
        pay_in.declared_fees.currency = MangoModel::CurrencyIso::EUR
        pay_in.declared_fees.amount = 30

        it 'creates the bank wire direct entity' do
          created = MangoApi::PayIns.create_client_bank_wire_direct pay_in
          expect(created).to be_kind_of MangoModel::BankWireDirectPayIn
          expect(created.id).not_to be_nil
          expect(created.status).to be MangoModel::TransactionStatus::CREATED
          expect(created.payment_type).to be MangoModel::PayInPaymentType::BANK_WIRE
          expect(created.execution_type).to be MangoModel::PayInExecutionType::DIRECT
          expect(created.bank_account).to be_kind_of MangoModel::BankAccount
          expect(created.credited_wallet_id).to eq pay_in.credited_wallet_id
          expect(its_the_same_money(pay_in.declared_debited_funds, created.declared_debited_funds)).to be_truthy
        end
      end
    end

    describe '#DIRECT_DEBIT WEB' do
      context 'given a valid object' do
        pay_in = DIRECT_DEBIT_WEB_PAY_IN_DATA

        it 'creates the direct-debit web pay-in entity' do
          created = MangoApi::PayIns.create_direct_debit_web pay_in

          expect(created).to be_kind_of MangoModel::DirectDebitWebPayIn
          expect(created.id).not_to be_nil
          expect(created.status).to be MangoModel::TransactionStatus::CREATED
          expect(created.payment_type).to be MangoModel::PayInPaymentType::DIRECT_DEBIT
          expect(created.execution_type).to be MangoModel::PayInExecutionType::WEB
          expect(its_the_same_direct_debit_web(pay_in, created)).to be_truthy
        end
      end
    end

    describe '#PAYPAL WEB' do
      context 'given a valid object' do
        pay_in = PAYPAL_PAY_IN_DATA

        it 'creates a paypal web payin' do
          created = MangoApi::PayIns.create_paypal_web pay_in

          expect(created).not_to be_nil
          expect(created.id).not_to be_nil
          expect(created.payment_type).to eq MangoModel::PayInPaymentType::PAYPAL
          expect(created.execution_type).to be MangoModel::PayInExecutionType::WEB
          expect(created.status).to be MangoModel::TransactionStatus::CREATED
        end
      end


      context 'given a payIn ID and a PayPal account email ' do
        payin_id = "54088959"
        buyer_account_email = "paypal-buyer-user@mangopay.com"
        it 'fetches the payin' do
          pay_in = MangoApi::PayIns.get payin_id

          expect(pay_in).not_to be_nil
          expect(pay_in.id).to eq payin_id
          expect(pay_in.paypal_buyer_account_email).to eq buyer_account_email
        end
      end

      context 'given an existing payin' do
        payin = PAYPAL_PAY_IN_PERSISTED
        it 'fetches the payin' do
          fetched = MangoApi::PayIns.get payin.id

          expect(fetched).not_to be_nil
          expect(its_the_same_paypal_web(payin, fetched)).to be_truthy
        end
      end
    end

    describe '#APPLE PAY DIRECT' do

      context 'given a valid object' do
        payin = APPLE_PAY_PAY_IN_DATA
        it 'creates an apple pay payin' do
          created = MangoApi::PayIns.create_apple_pay_direct payin

          expect(created).not_to be_nil
          expect(created.id).not_to be_nil
          expect(created.payment_type).to eq MangoModel::PayInPaymentType::APPLEPAY
          expect(created.execution_type).to be MangoModel::PayInExecutionType::DIRECT
          expect(created.status).to be MangoModel::TransactionStatus::SUCCEEDED
        end
      end

      context 'given an existing payin' do
        payin = APPLE_PAY_PAY_IN_PERSISTED
        it 'fetches the payin by id' do
          fetched = MangoApi::PayIns.get payin.id

          expect(fetched).not_to be_nil
          expect(its_the_same_paypal_web(payin, fetched)).to be_truthy
        end
      end
    end

    # describe '#DIRECT_DEBIT DIRECT' do
    #   context 'given a valid object' do
    #     mandate = MANDATE_PERSISTED
    #
    #     # Attention
    #     #
    #     # To make this test pass, you must pause execution with a breakpoint on
    #     # the following line, and use your browser to open the page received
    #     # in the +mandate.redirect_url+ property and click the Confirm button
    #     # before continuing
    #     expect(mandate.status).to be MangoModel::MandateStatus::SUBMITTED # Place breakpoint here
    #     pay_in = DIRECT_DEBIT_DIRECT_PAY_IN_DATA
    #
    #     it 'creates the direct-debit direct pay-in entity' do
    #       created = MangoApi::PayIns.create_direct_debit_direct pay_in
    #
    #       expect(created).to be_kind_of MangoModel::DirectDebitDirectPayIn
    #       expect(created.id).not_to be_nil
    #       expect(created.status).to be MangoModel::TransactionStatus::CREATED
    #       expect(created.payment_type).to be MangoModel::PayInPaymentType::DIRECT_DEBIT
    #       expect(created.execution_type).to be MangoModel::PayInExecutionType::DIRECT
    #       expect(its_the_same_direct_debit_direct(pay_in, created)).to be_truthy
    #     end
    #   end
    # end
  end

  # Fails with message 'Cannot found the ressource PayIn with the id=XXXXXXXX ',
  # even though a newly-created Pay-In's ID is used. API problem?
  #
  # describe '.get_extended_card_view' do
  #
  #   context "given an existing Card Web Pay-In entity's ID" do
  #     created = CARD_WEB_PAY_IN_PERSISTED
  #     id = created.id
  #
  #     it 'retrieves an extended detail view of the card used' do
  #       extended_card = MangoApi::PayIns.extended_card_view id
  #
  #       expect(extended_card).to be_kind_of MangoModel::PayInWebExtendedView
  #       expect(extended_card.id).to eq id
  #     end
  #   end
  # end

  describe '.get' do

    context "given an existing entity's ID" do
      created = CARD_WEB_PAY_IN_PERSISTED
      id = created.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::PayIns.get id

        expect(retrieved).to be_kind_of MangoModel::CardWebPayIn
        expect(retrieved.id).to eq id
        expect(its_the_same_card_web(created, retrieved)).to be_truthy
      end
    end
  end
end