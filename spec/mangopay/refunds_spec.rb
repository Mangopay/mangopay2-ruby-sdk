require_relative '../../lib/mangopay/api/service/refunds'
require_relative '../context/refund_context'
require_relative '../context/transfer_context'
require_relative '../context/pay_out_context'

describe MangoApi::Refunds do
  include_context 'refund_context'
  include_context 'transfer_context'
  include_context 'pay_out_context'

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

  describe '.of_pay_out' do

    context "given an existing entity's ID" do
      id = PAY_OUT_PERSISTED.id

      context 'not having specified filters' do
        results = MangoApi::Refunds.of_pay_out id

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Refund
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Refunds.of_pay_out id do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.status = MangoModel::TransactionStatus::CREATED
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Refund
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end

  describe '.of_pay_in' do

    context "given an existing entity's ID" do
      id = CARD_WEB_PAY_IN_PERSISTED.id

      context 'not having specified filters' do
        results = MangoApi::Refunds.of_pay_in id

        it 'retrieves list with default parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Refund
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        results = MangoApi::Refunds.of_pay_in id do |filter|
          filter.page = 1
          filter.per_page = 3
          filter.status = MangoModel::TransactionStatus::CREATED
        end

        it 'retrieves list with specified parameters' do
          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Refund
            expect(result.id).not_to be_nil
            expect(result.status).to be MangoModel::TransactionStatus::CREATED
          end
        end
      end
    end
  end
end