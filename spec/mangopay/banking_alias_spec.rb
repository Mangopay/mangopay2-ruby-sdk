require_relative '../context/banking_alias_context'
require_relative '../../lib/mangopay/api/service/banking_aliases'

describe MangoApi::BankingAliases do
  include_context 'banking_alias_context'

  describe 'get' do
    context 'given created wallets and aliases' do
      wallet = WALLET_DATA
      banking_alias = BANKING_ALIAS

      it 'gets a banking alias' do
        created = persist_wallet wallet
        expect(created).to be_kind_of MangoModel::Wallet
        expect(created.id).not_to be_nil
        expect(its_the_same_wallet(wallet, created)).to be_truthy

        banking_alias_created = MangoApi::BankingAliases.create_iban(banking_alias, created.id)

        received = MangoApi::BankingAliases.get banking_alias_created.id

        expect(received).not_to be_nil
      end

      it 'gets banking aliases' do
        created = persist_wallet wallet
        expect(created).to be_kind_of MangoModel::Wallet
        expect(created.id).not_to be_nil
        expect(its_the_same_wallet(wallet, created)).to be_truthy

        banking_alias_created = MangoApi::BankingAliases.create_iban(banking_alias, created.id)

        received = MangoApi::BankingAliases.get_all created.id

        expect(received).not_to be_nil
      end
    end
  end

  describe 'create' do
    context 'given a valid object' do
      wallet = WALLET_DATA
      banking_alias = BANKING_ALIAS
      it 'creates the banking alias entity' do
        created = persist_wallet wallet
        expect(created).to be_kind_of MangoModel::Wallet
        expect(created.id).not_to be_nil
        expect(its_the_same_wallet(wallet, created)).to be_truthy

        banking_alias_created = MangoApi::BankingAliases.create_iban(banking_alias, created.id)

        expect(banking_alias_created).not_to be_nil
      end
    end
  end

  describe  'update' do
    context 'given a banking alias' do
      wallet = WALLET_DATA
      banking_alias = BANKING_ALIAS
      it 'deactivates it' do
        created = persist_wallet wallet
        expect(created).to be_kind_of MangoModel::Wallet
        expect(created.id).not_to be_nil
        expect(its_the_same_wallet(wallet, created)).to be_truthy

        banking_alias_created = MangoApi::BankingAliases.create_iban(banking_alias, created.id)
        expect(banking_alias_created).not_to be_nil

        banking_alias_created.active = false

        banking_alias_updated = MangoApi::BankingAliases.update(banking_alias_created.id, banking_alias_created)

        expect(banking_alias_updated).not_to be_nil
        expect(banking_alias_updated.active).to be(false)

        get_again_banking = MangoApi::BankingAliases.get banking_alias_created.id

        expect(get_again_banking).not_to be_nil
        expect(get_again_banking.active).to be(false)
      end
    end
  end

end