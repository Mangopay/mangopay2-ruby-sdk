describe MangoPay::KycDocument do
  include_context 'kyc_documents'

  describe 'CREATE' do
    it 'creates a document' do
      expect(new_document['Id']).to_not be_nil
      expect(new_document['Type']).to eq('IDENTITY_PROOF')
      expect(new_document['Status']).to eq('CREATED')
      expect(new_document['RefusedReasonType']).to be_nil
      expect(new_document['RefusedReasonMessage']).to be_nil
    end
  end

  describe 'UPDATE' do
    it 'updates a document' do
      updated_document = MangoPay::KycDocument.update(new_natural_user['Id'], new_document['Id'], {
        Status: 'VALIDATION_ASKED'
      })
      expect(updated_document['Id']).to eq(new_document['Id'])
      expect(updated_document['Status']).to eq('VALIDATION_ASKED')
    end
  end

  describe 'FETCH' do
    it 'fetches a document' do
      document = MangoPay::KycDocument.fetch(new_natural_user['Id'], new_document['Id'])
      expect(document['Id']).to eq(new_document['Id'])
    end
  end

  describe 'CREATE PAGE' do

    def create_page(file)
      MangoPay::KycDocument.create_page(new_natural_user['Id'], new_document['Id'], file)
    end

    it 'accepts File instance' do
      file = File.open(__FILE__)
      ret = create_page(file)
      expect(ret).to be_nil
    end

    it 'accepts base64-encoded string' do
      file = Base64.encode64('any file content...')
      ret = create_page(file)
      expect(ret).to be_nil
    end

    it 'fails when input string is not base64-encoded' do
      file = 'any file content...'
      expect { create_page(file) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '400'
        expect(err.type).to eq 'param_error'
      }
    end
  end
end
