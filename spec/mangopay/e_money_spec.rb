require_relative '../context/user_context'
require_relative '../../lib/mangopay/api/service/e_money'

describe MangoApi::EMoney do
  include_context 'user_context'

  describe '.of_user_year' do

    describe "given an existing user entity's ID" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified currency' do
        default_currency = MangoModel::CurrencyIso::EUR
        year = 2019
        it "retrieves the corresponding e-money entity for year #{year} in default currency" do
          retrieved = MangoApi::EMoney.of_user_year id, year
          expect(retrieved).to be_kind_of MangoModel::EMoney
          expect(retrieved.credited_e_money.currency).to be default_currency
          expect(retrieved.debited_e_money.currency).to be default_currency
        end
      end

      # TODO: Results always come in EUR
      # context 'having specified currency' do
      #   currency = MangoModel::CurrencyIso::GBP
      #
      #   it 'retrieves the corresponding e-money entity in specified currency' do
      #     retrieved = MangoApi::EMoney.of_user id, currency
      #
      #     expect(retrieved).to be_kind_of MangoModel::EMoney
      #     expect(retrieved.credited_e_money.currency).to gebe currency
      #     expect(retrieved.debited_e_money.currency).to be currency
      #   end
      # end
    end
  end

  describe '.of_user_month' do

    describe "given an existing user entity's ID" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified currency' do
        default_currency = MangoModel::CurrencyIso::EUR

        year = 2019
        month = 4

        it "retrieves the corresponding e-money entity for date #{year}/#{month} in default currency" do
          retrieved = MangoApi::EMoney.of_user_month id, year, month
          expect(retrieved).to be_kind_of MangoModel::EMoney
          expect(retrieved.credited_e_money.currency).to be default_currency
          expect(retrieved.debited_e_money.currency).to be default_currency
        end
      end
    end
  end
end