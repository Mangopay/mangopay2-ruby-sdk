require_relative '../context/client_context'
require_relative '../../lib/mangopay/api/service/clients'
require_relative '../../lib/mangopay/api/service/client_wallets'
require_relative '../../lib/mangopay/model/entity/client_wallet'
require_relative '../../lib/mangopay/util/file_encoder'

describe MangoApi::Clients do
  include_context 'client_context'

  describe '.update' do

    context 'given a valid object' do
      client = CLIENT_DATA

      it 'updates the corresponding entity', :focus do
        updated = MangoApi::Clients.update client

        expect(updated).to be_kind_of MangoModel::Client
        expect(updated.name).not_to be_nil
        expect(updated.client_id).not_to be_nil
        expect(updated.logo).not_to be_nil
        expect(updated.headquarters_phone_number).not_to be_nil
        expect(its_the_same_client(client, updated)).to be_truthy
      end
    end
  end

  describe '.upload_logo' do

    context "given a valid image file's path" do
      path = File.join(File.dirname(__FILE__), '..', 'resources', 'logo.png')
      base64_to_upload = FileEncoder.encode_base64(path)

      it "uploads the image as the client's logo" do
        MangoApi::Clients.upload_logo path

        client = MangoApi::Clients.get
        uploaded_logo_uri = URI(client.logo)
        uploaded_image = MangoApi::HttpClient.get_raw(uploaded_logo_uri)
        uploaded_base64 = Base64.strict_encode64(uploaded_image)

        expect(base64_to_upload).to eq uploaded_base64
      end
    end
  end

  describe '.get' do

    context 'from a correctly-configured environment' do
      it "retrieves the environment's Client entity" do
        retrieved = MangoApi::Clients.get

        expect(retrieved).to be_kind_of MangoModel::Client
        expect(retrieved.client_id).to eq MangoPay.configuration.client_id
        expect(retrieved.platform_categorization).to be_kind_of MangoModel::PlatformCategorization
      end
    end
  end

  describe '.create_bank_account' do
    it "creates a new bank account" do
      account = MangoModel::IbanBankAccount.new
      account.owner_name = 'John'

      address = MangoModel::Address.new
      address.address_line1 = 'Le Palais Royal'
      address.address_line2 = 'test'
      address.city = 'Paris'
      address.postal_code = '75001'
      address.country = 'FR'
      account.owner_address = address

      account.iban = 'FR7618829754160173622224154'
      account.bic = 'CMBRFR2BCME'
      account.tag = 'custom meta'

      created_account = MangoApi::Clients.create_bank_account(account)

      expect(created_account).not_to be_nil
      expect(created_account.id).not_to be_nil
    end
  end

  describe '.create_payout' do
    it "creates a new payout" do
      account = MangoModel::IbanBankAccount.new
      payout = MangoModel::PayOut.new
      account.owner_name = 'John'

      address = MangoModel::Address.new
      address.address_line1 = 'Le Palais Royal'
      address.address_line2 = 'test'
      address.city = 'Paris'
      address.postal_code = '75001'
      address.country = 'FR'
      account.owner_address = address

      account.iban = 'FR7618829754160173622224154'
      account.bic = 'CMBRFR2BCME'
      account.tag = 'custom meta'

      debited_funds = MangoModel::Money.new
      debited_funds.currency = 'EUR'
      debited_funds.amount = 12

      created_account = MangoApi::Clients.create_bank_account(account)
      wallets = MangoApi::ClientWallets.all

      payout.debited_funds = debited_funds
      payout.bank_account_id = created_account.id
      payout.debited_wallet_id = wallets[0].id
      payout.bank_wire_ref = 'invoice 7282'
      payout.tag = 'bla'

      created_payout = MangoApi::Clients.create_payout(payout)

      expect(created_payout).not_to be_nil
      expect(created_payout.id).not_to be_nil
    end
  end
end