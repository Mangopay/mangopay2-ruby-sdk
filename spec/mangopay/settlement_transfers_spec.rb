require_relative '../../lib/mangopay/api/service/settlement_transfers'
require_relative '../context/settlement_transfer_context'

describe MangoApi::SettlementTransfers do
  include_context 'settlement_transfer_context'

  describe '.create' do

    context 'given a valid object' do
      id = REPUDIATION_PERSISTED.id
      transfer = SETTLEMENT_TRANSFER_DATA

      it 'creates the settlement transfer entity' do
        created = MangoApi::SettlementTransfers.create(id, transfer)

        expect(created).to be_kind_of MangoModel::SettlementTransfer
        expect(created.id).not_to be_nil
        expect(created.repudiation_id).to eq id
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      transfer = SETTLEMENT_TRANSFER_PERSISTED
      id = transfer.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::SettlementTransfers.get id

        expect(retrieved).to be_kind_of MangoModel::SettlementTransfer
        expect(retrieved.id).to eq id
      end
    end
  end
end