require_relative '../../lib/mangopay/api/service/disputes'
require_relative '../../lib/mangopay/api/service/repudiations'
require_relative '../context/dispute_context'
require_relative '../context/repudiation_context'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::Disputes do
  include_context 'dispute_context'
  include_context 'repudiation_context'

  describe '.update' do

    context 'given a valid object' do
      tag = 'Updated tag'
      existing = DISPUTE_PERSISTED
      existing.tag = tag

      it 'updates the corresponding entity' do
        updated = MangoApi::Disputes.update existing

        expect(updated).to be_kind_of MangoModel::Dispute
        expect(updated.id).to eq existing.id
        expect(updated.tag).to eq tag
        expect(its_the_same_dispute(existing, updated)).to be_truthy
      end
    end
  end

  describe '.close' do

    context "given an existing entity's ID" do
      id = DISPUTE_PERSISTED.id

      it 'closes the corresponding dispute entity' do
        expect { MangoApi::Disputes.close id }.to(raise_error { |err|
          expect(err).to be_kind_of MangoPay::ResponseError
          expect(err.type).to eq 'dispute_cant_be_closed'
        })
      end
    end
  end

  describe '.submit' do

    context 'given a valid object' do
      dispute = DISPUTE_PERSISTED

      it 'contests the corresponding dispute entity' do
        expect { MangoApi::Disputes.submit dispute }.to(raise_error { |err|
          expect(err).to be_kind_of MangoPay::ResponseError
          expect(err.type).to eq 'dispute_contest_deadline_passed'
        })
      end
    end
  end

  describe '.resubmit' do

    context "given an existing entity's ID" do
      id = DISPUTE_PERSISTED.id

      it 'resubmits the corresponding dispute entity' do
        expect { MangoApi::Disputes.resubmit id }.to(raise_error { |err|
          expect(err).to be_kind_of MangoPay::ResponseError
          expect(err.type).to eq 'dispute_contest_deadline_passed'
        })
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      existing = DISPUTE_PERSISTED
      id = existing.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::Disputes.get id

        expect(retrieved).to be_kind_of MangoModel::Dispute
        expect(retrieved.id).to eq id
        expect(its_the_same_dispute(existing, retrieved)).to be_truthy
      end
    end
  end

  describe '.of_user' do

    context "given an existing user entity's ID" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified filters' do
        it 'retrieves list with default parameters' do
          results = MangoApi::Disputes.of_user id

          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        it 'retrieves list with specified parameters' do
          results = MangoApi::Disputes.of_user id do |filter|
            filter.page = 1
            filter.per_page = 5
            filter.status = MangoModel::DisputeStatus::CREATED
          end

          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end

  describe '.of_wallet' do

    context "given an existing wallet entity's ID" do
      id = WALLET_PERSISTED.id

      context 'not having specified filters' do
        it 'retrieves list with default parameters' do
          results = MangoApi::Disputes.of_wallet id

          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        it 'retrieves list with specified parameters' do
          results = MangoApi::Disputes.of_wallet id do |filter|
            filter.page = 1
            filter.per_page = 5
          end

          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
          end
        end
      end
    end
  end

  describe '.pending_settlement' do

    context 'from a correctly-configured environment' do
      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::Disputes.pending_settlement

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        per_page = 11

        it 'retrieves list with specified parameters' do
          results = MangoApi::Disputes.pending_settlement do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::DESC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date >= second_date).to be_truthy
          end
        end
      end
    end
  end

  describe '.all' do

    context 'from a correctly-configured environment' do
      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::Disputes.all

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
          end
        end
      end

      context 'having specified filters' do
        per_page = 11
        status = MangoModel::DisputeStatus::CLOSED

        it 'retrieves list with specified parameters' do
          results = MangoApi::Disputes.all do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::DESC
            filter.status = status
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Dispute
            expect(result.id).not_to be_nil
            expect(result.status).to be status
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date >= second_date).to be_truthy
          end
        end
      end
    end
  end
end

describe MangoApi::Repudiations do

  describe '.get' do

    context "given an existing entity's ID" do
      id = REPUDIATION_PERSISTED.id

      it 'retrieves the corresponding entity' do
        expect(id).not_to be_nil, 'there is no repudiation to retrieve'
        retrieved = MangoApi::Repudiations.get id

        expect(retrieved).to be_kind_of MangoModel::Repudiation
        expect(retrieved.id).not_to be_nil
      end
    end
  end
end