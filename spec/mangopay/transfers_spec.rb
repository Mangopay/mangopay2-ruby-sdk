require_relative '../context/transfer_context'
require_relative '../../lib/mangopay/api/service/transfers'

describe MangoApi::Transfers do
  include_context 'transfer_context'

  describe '.create' do

    context 'given a valid object' do
      transfer = TRANSFER_DATA

      it 'creates the transfer entity' do
        created = MangoApi::Transfers.create transfer

        expect(created).to be_kind_of MangoModel::Transfer
        expect(created.id).not_to be_nil
        debited = created.debited_funds.amount
        fees = created.fees.amount
        credited = created.credited_funds.amount
        expect(debited - fees == credited).to be_truthy
        expect(its_the_same_transfer(transfer, created)).to be_truthy
      end
    end
  end

  context "given an existing entity's ID" do
    created = TRANSFER_PERSISTED
    id = created.id

    it 'retrieves the corresponding entity' do
      retrieved = MangoApi::Transfers.get id

      expect(retrieved).to be_kind_of MangoModel::Transfer
      expect(retrieved.id).to eq id
      expect(its_the_same_transfer(created, retrieved)).to be_truthy
    end
  end
end