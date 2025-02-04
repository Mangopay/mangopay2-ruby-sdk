describe MangoPay::KycDocument do
  include_context 'kyc_documents'

  describe 'CREATE' do
    it 'creates a document' do
      expect(new_document['Id']).to_not be_nil
      expect(new_document['Type']).to eq('IDENTITY_PROOF')
      expect(new_document['Status']).to eq('CREATED')
      expect(new_document['RefusedReasonType']).to be_nil
      expect(new_document['RefusedReasonMessage']).to be_nil
      expect(new_document['Flags']).to match_array([])
    end
  end

  describe 'UPDATE' do
    it 'updates a document' do
      fnm = __FILE__.sub('.rb', '.png')
      ret = MangoPay::KycDocument.create_page(new_natural_user['Id'], new_document['Id'], nil, fnm)
      
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

    it 'fetches a document just by id' do
      document = MangoPay::KycDocument.fetch(nil, new_document['Id'])
      expect(document['Id']).to eq(new_document['Id'])
    end
  end

  describe 'FETCH ALL' do
    it 'fetches a list of documents' do
      usr1 = create_new_natural_user()
      usr2 = create_new_natural_user()
      doc1 = create_new_document(usr1)
      doc2 = create_new_document(usr1)
      doc3 = create_new_document(usr2)

      # fetch all docs for user 1
      docs = MangoPay::KycDocument.fetch_all(usr1['Id'])
      expect(docs).to be_kind_of(Array)
      expect(docs.count).to eq 2
      expect(docs[0]['Id']).to eq doc1['Id']
      expect(docs[1]['Id']).to eq doc2['Id']

      # fetch all docs for user 2
      docs = MangoPay::KycDocument.fetch_all(usr2['Id'])
      expect(docs).to be_kind_of(Array)
      expect(docs.count).to eq 1
      expect(docs[0]['Id']).to eq doc3['Id']

      # fetch all docs ever
      docs = MangoPay::KycDocument.fetch_all(nil, {'afterdate' => doc1['CreationDate'] - 500, 'beforedate' => doc1['CreationDate'] + 500})
      expect(docs).to be_kind_of(Array)
      expect(docs.count).to be >= 3 # at least last 3 docs, but probably many more

      # fetch last 3 docs (sorting by date descending)
      docs = MangoPay::KycDocument.fetch_all(nil, filter = {'page' => 1, 'per_page' => 3, 'sort' => 'CreationDate:desc', 'afterdate' => doc1['CreationDate'] - 500, 'beforedate' => doc1['CreationDate'] + 500})
      expect(docs).to be_kind_of(Array)
      expect(docs.count).to eq 3
      # all 3 are at top as lastly created
      # but may share the same CreationDate
      # so the order between them is undetermined
      expect(docs).to include(doc1, doc2, doc3)

    end
  end

  describe 'CREATE PAGE' do

    def create_page(file)
      MangoPay::KycDocument.create_page(new_natural_user['Id'], new_document['Id'], file)
    end

    it 'accepts Base64 encoded file content' do
      fnm = __FILE__.sub('.rb', '.png')
      bts = File.open(fnm, 'rb') { |f| f.read }
      b64 = Base64.encode64(bts)
      ret = create_page(b64)
      expect(ret).to be_nil
    end

    it 'accepts file path' do
      fnm = __FILE__.sub('.rb', '.png')
      ret = MangoPay::KycDocument.create_page(new_natural_user['Id'], new_document['Id'], nil, fnm)
      expect(ret).to be_nil
    end

    it 'fails when input string is not base64-encoded' do
      file = 'any file content...'
      expect { create_page(file) }.to raise_error { |err|
        expect(err).to be_a MangoPay::ResponseError
        expect(err.code).to eq '500'
        # expect(err.code).to eq '400'
        # expect(err.type).to eq 'param_error'
      }
    end

    describe 'CREATE CONSULT' do
      it 'creates document pages consult' do
        fnm = __FILE__.sub('.rb', '.png')
        MangoPay::KycDocument.create_page(new_natural_user['Id'], new_document['Id'], nil, fnm)

        consult = MangoPay::KycDocument.create_documents_consult(new_document['Id'])
        expect(consult).not_to be_nil
        expect(consult).to be_kind_of(Array)
      end
    end
  end
end
