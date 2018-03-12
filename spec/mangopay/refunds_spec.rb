require_relative '../../lib/mangopay/api/service/refunds'
require_relative '../context/refund_context'
require_relative '../context/transfer_context'

describe MangoApi::Refunds do
  include_context 'refund_context'
  include_context 'transfer_context'

  describe '.create_for_pay_in' do

    context "given an existing pay-in entity's ID and a valid object" do
      id = CARD_DIRECT_PAY_IN_PERSISTED.id
      refund = build_pay_in_refund

      it 'creates the refund entity' do
        created = MangoApi::Refunds.create_for_pay_in(id, refund)

        expect(created).to be_kind_of MangoModel::Refund
        expect(created.id).not_to be_nil
        expect(created.status).to be MangoModel::TransactionStatus::SUCCEEDED
      end
    end
  end

  describe '.create_for_transfer' do

    context "given an existing transfer entity's ID and a valid object" do
      id = TRANSFER_PERSISTED.id
      refund = TRANSFER_REFUND_DATA

      it 'creates the refund entity' do
        created = MangoApi::Refunds.create_for_transfer(id, refund)

        expect(created).to be_kind_of MangoModel::Refund
        expect(created.id).not_to be_nil
        expect(created.status).to be MangoModel::TransactionStatus::SUCCEEDED
      end
    end
  end
end