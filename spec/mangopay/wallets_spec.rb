require_relative '../context/wallet_context'
require_relative '../../lib/mangopay/api/service/wallets'
require_relative '../../lib/mangopay/common/sort_direction'
require_relative '../../lib/mangopay/common/sort_field'

describe MangoApi::Wallets do
  include_context 'wallet_context'

  describe '.create' do

    context 'given a valid object' do
      wallet = WALLET_DATA

      it 'creates the wallet entity' do
        created = persist_wallet wallet
        expect(created).to be_kind_of MangoModel::Wallet
        expect(created.id).not_to be_nil
        expect(its_the_same_wallet(wallet, created)).to be_truthy
      end
    end
  end

  describe '.update' do
    updated_value = 'Updated'.freeze

    context 'given a valid object' do
      created = WALLET_PERSISTED
      created.description = updated_value

      it 'updated the corresponding entity' do
        updated = MangoApi::Wallets.update created

        expect(updated).to be_kind_of MangoModel::Wallet
        expect(updated.id).to eq created.id
        expect(updated.description).to eq updated_value
        expect(its_the_same_wallet(created, updated)).to be_truthy
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      wallet = WALLET_PERSISTED
      id = wallet.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::Wallets.get id

        expect(retrieved).to be_kind_of MangoModel::Wallet
        expect(retrieved.id).to eq id
        expect(its_the_same_wallet(wallet, retrieved)).to be_truthy
      end
    end
  end

  describe '.of_user' do
    # prepare some test data
    10.times do
      persist_wallet WALLET_DATA
    end

    context "given an existing user entity's ID" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified filters' do
        default_per_page = 10

        it 'retrieves list with default parameters' do
          results = MangoApi::Wallets.of_user id

          expect(results).to be_kind_of Array
          expect(results.length).to eq default_per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Wallet
            expect(result.owners.include?(id)).to be_truthy
          end
        end
      end

      context 'having specified filters' do
        per_page = 3
        results = MangoApi::Wallets.of_user id do |filter|
          filter.page = 1
          filter.per_page = per_page
          filter.sort_field = MangoPay::SortField::CREATION_DATE
          filter.sort_direction = MangoPay::SortDirection::ASC
        end

        it 'retrieves list according to provided parameters' do
          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each.with_index do |result, index|
            expect(result).to be_kind_of MangoModel::Wallet
            next if index == results.length - 1
            first_date = result.creation_date
            second_date = results[index + 1].creation_date
            expect(first_date <= second_date).to be_truthy
          end
        end
      end
    end
  end
end