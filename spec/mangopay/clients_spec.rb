require_relative '../context/client_context'
require_relative '../../lib/mangopay/api/service/clients'
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
end