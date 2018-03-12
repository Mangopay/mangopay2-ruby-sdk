require 'securerandom'
require_relative '../context/bank_account_context'
require_relative '../context/transfer_context'
require_relative '../context/pay_out_context'
require_relative '../context/kyc_document_context'
require_relative '../context/ubo_declaration_context'
require_relative '../context/refund_context'
require_relative '../../lib/mangopay/api/service/bank_accounts'
require_relative '../../lib/mangopay/api/service/responses'
require_relative '../../lib/mangopay/api/service/cards'
require_relative '../../lib/mangopay/api/service/pay_ins'
require_relative '../../lib/mangopay/api/service/pay_outs'
require_relative '../../lib/mangopay/api/service/refunds'
require_relative '../../lib/mangopay/model/response_replica'

describe MangoApi::Responses do
  include_context 'bank_account_context'
  include_context 'transfer_context'
  include_context 'pay_out_context'
  include_context 'kyc_document_context'
  include_context 'ubo_declaration_context'
  include_context 'refund_context'

  describe '.replicate' do

    describe '#User' do

      describe '#Natural' do
        context "given a successful POST request's idempotency key" do
          idempotency_key = SecureRandom.uuid
          user = MangoApi::Users.create(NATURAL_USER_DATA, idempotency_key)

          it 'retrieves a replica of the original response' do
            replica = MangoApi::Responses.replicate idempotency_key

            expect(replica.resource).to be_kind_of MangoModel::NaturalUser
            expect(replica.resource.id).to eq user.id
            expect(its_the_same_natural(user, replica.resource)).to be_truthy
          end
        end
      end
    end

    describe '#BankAccount' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        account = MangoApi::BankAccounts.create(IBAN_ACCOUNT_DATA,
                                                idempotency_key)

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::IbanBankAccount
          expect(replica.resource.id).to eq account.id
          expect(its_the_same_iban(account, replica.resource)).to be_truthy
        end
      end
    end

    describe '#Wallet' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        wallet = MangoApi::Wallets.create(WALLET_DATA, idempotency_key)

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::Wallet
          expect(replica.resource.id).to eq wallet.id
          expect(its_the_same_wallet(wallet, replica.resource)).to be_truthy
        end
      end
    end

    describe '#Transfer' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        transfer = MangoApi::Transfers.create(TRANSFER_DATA, idempotency_key)

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::Transfer
          expect(replica.resource.id).to eq transfer.id
          expect(its_the_same_transfer(transfer, replica.resource)).to be_truthy
        end
      end
    end

    describe '#CardRegistration' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        card_registration = MangoApi::Cards.create_registration(CARD_REGISTRATION_DATA, idempotency_key)

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate(idempotency_key)

          expect(replica.resource).to be_kind_of MangoModel::CardRegistration
          expect(replica.resource.id).to eq card_registration.id
        end
      end
    end

    describe '#PreAuthorization' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        pre_authorization = MangoApi::PreAuthorizations.create(PRE_AUTHORIZATION_DATA, idempotency_key)

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::PreAuthorization
          expect(replica.resource.id).to eq pre_authorization.id
          expect(its_the_same_pre_auth(pre_authorization, replica.resource)).to be_truthy
        end
      end
    end

    describe '#PayIn' do

      describe '#CARD WEB' do
        context "given a successful POST request's idempotency key" do
          idempotency_key = SecureRandom.uuid
          pay_in = MangoApi::PayIns.create_card_web(CARD_WEB_PAY_IN_DATA, idempotency_key)

          it 'retrieves a replica of the original response' do
            replica = MangoApi::Responses.replicate idempotency_key

            expect(replica.resource).to be_kind_of MangoModel::CardWebPayIn
            expect(replica.resource.id).to eq pay_in.id
            expect(its_the_same_card_web(pay_in, replica.resource)).to be_truthy
          end
        end
      end

      describe '#CARD DIRECT' do
        context "given a successful POST request's idempotency key" do
          idempotency_key = SecureRandom.uuid
          pay_in = MangoApi::PayIns.create_card_direct(CARD_DIRECT_PAY_IN_DATA, idempotency_key)

          it 'retrieves a replica of the original response' do
            replica = MangoApi::Responses.replicate idempotency_key

            expect(replica.resource).to be_kind_of MangoModel::CardDirectPayIn
            expect(replica.resource.id).to eq pay_in.id
            expect(its_the_same_card_direct(pay_in, replica.resource)).to be_truthy
          end
        end
      end

      describe '#CARD PREAUTHORIZED' do
        context "given a successful POST request's idempotency key" do
          idempotency_key = SecureRandom.uuid

          it 'retrieves a replica of the original response' do
            pay_in_data = build_card_pre_auth_pay_in
            # noinspection RubyResolve
            pay_in_data.preauthorization_id = new_pre_authorization_persisted.id
            pay_in = MangoApi::PayIns.create_card_pre_authorized(pay_in_data, idempotency_key)
            replica = MangoApi::Responses.replicate idempotency_key

            expect(replica.resource).to be_kind_of MangoModel::CardPreAuthorizedPayIn
            expect(replica.resource.id).to eq pay_in.id
            expect(its_the_same_card_pre_auth(pay_in, replica.resource)).to be_truthy
          end
        end
      end

      describe '#BANK_WIRE DIRECT' do
        context "given a successful POST request's idempotency key" do
          idempotency_key = SecureRandom.uuid
          pay_in = MangoApi::PayIns.create_bank_wire_direct(BANK_WIRE_DIRECT_PAY_IN_DATA, idempotency_key)

          it 'retrieves a replica of the original response' do
            replica = MangoApi::Responses.replicate idempotency_key

            expect(replica.resource).to be_kind_of MangoModel::BankWireDirectPayIn
            expect(replica.resource.id).to eq pay_in.id
            expect(its_the_same_bank_wire_direct(pay_in, replica.resource)).to be_truthy
          end
        end
      end

      describe '#DIRECT_DEBIT WEB' do
        context "given a successful POST request's idempotency key" do
          idempotency_key = SecureRandom.uuid
          pay_in = MangoApi::PayIns.create_direct_debit_web(DIRECT_DEBIT_WEB_PAY_IN_DATA, idempotency_key)

          it 'retrieves a replica of the original response' do
            replica = MangoApi::Responses.replicate idempotency_key

            expect(replica.resource).to be_kind_of MangoModel::DirectDebitWebPayIn
            expect(replica.resource.id).to eq pay_in.id
            expect(its_the_same_direct_debit_web(pay_in, replica.resource)).to be_truthy
          end
        end
      end

      describe '#DIRECT_DEBIT DIRECT' do
        context "given a successful POST request's idempotency key" do
          idempotency_key = SecureRandom.uuid
          pay_in = MangoApi::PayIns.create_direct_debit_direct(DIRECT_DEBIT_DIRECT_PAY_IN_DATA, idempotency_key)

          it 'retrieves a replica of the original response' do
            replica = MangoApi::Responses.replicate idempotency_key

            expect(replica.resource).to be_kind_of MangoModel::DirectDebitDirectPayIn
            expect(replica.resource.id).to eq pay_in.id
            expect(its_the_same_direct_debit_direct(pay_in, replica.resource)).to be_truthy
          end
        end
      end
    end

    describe '#Mandate' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        mandate = MangoApi::Mandates.create(MANDATE_DATA, idempotency_key)

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::Mandate
          expect(replica.resource.id).to eq mandate.id
          expect(its_the_same_mandate(mandate, replica.resource)).to be_truthy
        end
      end
    end

    describe '#PayOut' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        pay_out = MangoApi::PayOuts.create(PAY_OUT_DATA, idempotency_key)

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::PayOut
          expect(replica.resource.id).to eq pay_out.id
          expect(its_the_same_pay_out(pay_out, replica.resource)).to be_truthy
        end
      end
    end

    describe '#KycDocument' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        kyc_doc = MangoApi::KycDocuments.create KYC_DOCUMENT_DATA,
                                                NATURAL_USER_PERSISTED.id,
                                                idempotency_key

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::KycDocument
          expect(replica.resource.id).to eq kyc_doc.id
          expect(its_the_same_kyc_doc(kyc_doc, replica.resource)).to be_truthy
        end
      end
    end

    describe '#UboDeclaration' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        ubo_decl = MangoApi::UboDeclarations.create UBO_DECLARATION_DATA,
                                                    LEGAL_USER_PERSISTED.id,
                                                    idempotency_key

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::UboDeclaration
          expect(replica.resource.id).to eq ubo_decl.id
        end
      end
    end

    describe '#Refund' do
      context "given a successful POST request's idempotency key" do
        idempotency_key = SecureRandom.uuid
        transfer = MangoApi::Transfers.create TRANSFER_DATA
        refund = MangoApi::Refunds.create_for_transfer transfer.id,
                                                       TRANSFER_REFUND_DATA,
                                                       idempotency_key

        it 'retrieves a replica of the original response' do
          replica = MangoApi::Responses.replicate idempotency_key

          expect(replica.resource).to be_kind_of MangoModel::Refund
          expect(replica.resource.id).to eq refund.id
        end
      end
    end
  end
end