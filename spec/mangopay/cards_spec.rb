require_relative '../context/card_context'
require_relative '../../lib/mangopay/api/service/cards'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::Cards do
  include_context 'card_context'

  describe '.create_registration' do

    context 'given a valid object' do
      card_registration = CARD_REGISTRATION_DATA

      it 'creates the card registration entity' do
        retrieved = MangoApi::Cards.create_registration card_registration

        expect(retrieved).to be_kind_of MangoModel::CardRegistration
        expect(retrieved.id).not_to be_nil
        expect(retrieved.access_key).not_to be_nil
        expect(retrieved.card_registration_url).not_to be_nil
        expect(retrieved.preregistration_data).not_to be_nil
        expect(retrieved.status).to be MangoModel::CardStatus::CREATED
      end
    end
  end

  describe '.complete_registration' do

    context 'given the registration data from Tokenization Server' do
      it 'completes the card registration process' do
        created = CARD_REGISTRATION_PERSISTED
        completed = CARD_REGISTRATION_COMPLETED
        expect(completed).to be_kind_of MangoModel::CardRegistration
        expect(completed.id).to eq created.id
        expect(completed.status).to be MangoModel::CardStatus::VALIDATED
        expect(completed.card_id).not_to be_nil
      end
    end
  end

  describe '.get_registration' do

    context "given an existing entity's ID" do
      card_registration = CARD_REGISTRATION_PERSISTED
      id = card_registration.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::Cards.get_registration id

        expect(retrieved).to be_kind_of MangoModel::CardRegistration
        expect(retrieved.id).to eq card_registration.id
      end
    end
  end

  describe '.get' do

    context "given a validated card entity's ID" do
      id = CARD_REGISTRATION_COMPLETED.card_id
      retrieved = MangoApi::Cards.get id

      it 'retrieves the corresponding card entity' do
        expect(retrieved).to be_kind_of MangoModel::Card
        card = retrieved
        expect(card.id).to eq id
        expect(card.active).to be_truthy
        expect(card.card_type).to be MangoModel::CardType::CB_VISA_MASTERCARD
        expect(card.currency).to be MangoModel::CurrencyIso::EUR
        expect(card.expiration_date).to eq CARD_EXPIRATION
        expect(card.fingerprint).not_to be_nil
        expect(card.user_id).to eq CARD_REGISTRATION_COMPLETED.user_id
        expect(card.validity).to be MangoModel::CardValidity::UNKNOWN
      end
    end
  end

  describe '.of_user' do

    context "given a valid user entity's ID" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified filters' do
        it 'retrieves list with default parameters' do
          results = MangoApi::Cards.of_user id

          expect(results).to be_kind_of Array
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Card
            expect(result.id).not_to be_nil
            expect(result.user_id).to eq id
          end
        end
      end

      context 'having specified filters' do
        per_page = 1

        it 'retrieves list with specified parameters' do
          results = MangoApi::Cards.of_user id do |filter|
            filter.page = 1
            filter.per_page = per_page
            filter.sort_field = MangoPay::SortField::CREATION_DATE
            filter.sort_direction = MangoPay::SortDirection::ASC
          end

          expect(results).to be_kind_of Array
          expect(results.length).to eq per_page
          results.each do |result|
            expect(result).to be_kind_of MangoModel::Card
            expect(result.id).not_to be_nil
            expect(result.user_id).to eq id
          end
        end
      end
    end

    # Currently disabled because it deactivates the only testing card.
    # Works if ran alone.
    #
    # describe '.deactivate' do
    #
    #   context "given a valid card entity's ID" do
    #     it 'deactivates the corresponding card entity' do
    #       card = CARD
    #       id = card.id
    #       deactivated = MangoApi::Cards.deactivate id
    #
    #       expect(deactivated).to be_kind_of MangoModel::Card
    #       expect(deactivated.id).to eq id
    #       expect(deactivated.active).to be_falsey
    #     end
    #   end
    # end
  end
end