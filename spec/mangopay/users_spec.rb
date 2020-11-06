require_relative '../context/user_context'
require_relative '../../lib/mangopay/api/service/users'
require_relative '../../lib/mangopay/common/sort_direction'
require_relative '../../lib/mangopay/common/sort_field'

describe MangoApi::Users do
  include_context 'user_context'

  describe '.create' do

    describe '#Natural' do
      context 'given a valid object' do
        user = NATURAL_USER_DATA

        it 'creates the natural user entity' do
          created = persist_user user

          expect(created).to be_kind_of MangoModel::NaturalUser
          expect(created.id).not_to be_nil
          expect(its_the_same_user(user, created)).to be_truthy
        end
      end
    end

    describe '#Legal' do
      context 'given a valid object' do
        user = LEGAL_USER_DATA

        it 'creates the legal user entity' do
          persisted = persist_user user

          expect(persisted).to be_kind_of MangoModel::LegalUser
          expect(persisted.id).not_to be_nil
          expect(its_the_same_user(user, persisted)).to be_truthy
        end
      end
    end
  end

  describe '.update' do
    updated_value = 'Updated'.freeze

    describe '#Natural' do
      context 'given a valid object' do
        created = NATURAL_USER_PERSISTED
        created.first_name = updated_value

        it 'updates the corresponding entity' do
          updated = MangoApi::Users.update created

          expect(updated).to be_kind_of MangoModel::NaturalUser
          expect(updated.id).to eq created.id
          expect(updated.first_name).to eq updated_value
          expect(its_the_same_user(created, updated)).to be_truthy
        end
      end
    end

    describe '#Legal' do
      context 'given a valid object' do
        created = LEGAL_USER_PERSISTED
        created.name = updated_value

        it 'updates the corresponding entity' do
          updated = MangoApi::Users.update created

          expect(updated).to be_kind_of MangoModel::LegalUser
          expect(updated.id).to eq created.id
          expect(updated.name).to eq updated_value
          expect(its_the_same_user(created, updated)).to be_truthy
        end
      end
    end
  end

  describe '.get' do

    describe '#Natural' do
      context "given an existing entity's ID" do
        created = NATURAL_USER_PERSISTED
        id = created.id

        it 'retrieves the corresponding entity' do
          retrieved = MangoApi::Users.get id

          expect(retrieved).to be_kind_of MangoModel::NaturalUser
          expect(retrieved.id).to eq id
          expect(its_the_same_user(created, retrieved)).to be_truthy
        end
      end
    end

    describe '#Legal' do
      context "given an existing entity's ID" do
        created = LEGAL_USER_PERSISTED
        id = created.id

        it 'retrieves the corresponding entity' do
          retrieved = MangoApi::Users.get id

          expect(retrieved).to be_kind_of MangoModel::LegalUser
          expect(retrieved.id).to eq id
          expect(its_the_same_user(created, retrieved)).to be_truthy
        end
      end
    end
  end

  describe '.all' do
    default_per_page = 10

    context 'not having specified filters' do
      results = MangoApi::Users.all

      it 'retrieves list with default parameters' do
        expect(results).to be_kind_of Array
        expect(results.length).to eq default_per_page
        results.each do |result|
          expect(result).to be_kind_of MangoModel::User
        end
      end
    end

    context 'having specified filters' do
      per_page = 15
      results = MangoApi::Users.all do |filter|
        filter.page = 1
        filter.per_page = per_page
        filter.sort_field = MangoPay::SortField::CREATION_DATE
        filter.sort_direction = MangoPay::SortDirection::ASC
      end

      it 'retrieves list according to provided parameters' do
        expect(results).to be_kind_of Array
        expect(results.length).to eq per_page
        results.each.with_index do |result, index|
          expect(result).to be_kind_of MangoModel::User
          next if index == results.length - 1
          first_date = result.creation_date
          second_date = results[index + 1].creation_date
          expect(first_date <= second_date).to be_truthy
        end
      end
    end
  end

  describe '..get_block_status' do

    describe '#BlockStatus' do
      context "given an existing user's ID" do
        created = NATURAL_USER_PERSISTED
        id = created.id

        it 'retrieves the block status' do
          retrieved = MangoApi::Users.get_block_status id

          expect(retrieved).not_to be_nil
          expect(retrieved).to be_kind_of MangoModel::UserBlockStatus
        end
      end
    end
  end
end