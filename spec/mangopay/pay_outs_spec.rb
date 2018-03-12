require_relative '../../lib/mangopay/api/service/pay_outs'
require_relative '../context/pay_out_context'

describe MangoApi::PayOuts do
  include_context 'pay_out_context'

  describe '.create' do

    context 'given a valid object' do
      pay_out = PAY_OUT_DATA

      it 'creates the pay-out entity' do
        created = MangoApi::PayOuts.create pay_out

        expect(created).to be_kind_of MangoModel::PayOut
        expect(created.id).not_to be_nil
        expect(created.payment_type).to be MangoModel::PayOutPaymentType::BANK_WIRE
        expect(created.status).to be MangoModel::TransactionStatus::CREATED
        expect(its_the_same_pay_out(pay_out, created)).to be_truthy
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      created = PAY_OUT_PERSISTED
      id = created.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::PayOuts.get id

        expect(retrieved).to be_kind_of MangoModel::PayOut
        expect(retrieved.id).to eq id
        expect(its_the_same_pay_out(created, retrieved)).to be_truthy
      end
    end
  end
end