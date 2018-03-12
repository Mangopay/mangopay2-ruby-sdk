require_relative '../context/user_context'
require_relative '../../lib/mangopay/api/service/e_money'

describe MangoApi::EMoney do
  include_context 'user_context'

  describe '.of_user' do

    describe "given an existing user entity's ID" do
      id = NATURAL_USER_PERSISTED.id

      context 'not having specified currency' do
        default_currency = MangoModel::CurrencyIso::EUR

        it 'retrieves the corresponding e-money entity in default currency' do
          retrieved = MangoApi::EMoney.of_user id

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
      #     expect(retrieved.credited_e_money.currency).to be currency
      #     expect(retrieved.debited_e_money.currency).to be currency
      #   end
      # end
    end
  end
end