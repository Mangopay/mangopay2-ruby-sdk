require_relative 'user_context'
require_relative '../../lib/mangopay/api/service/kyc_documents'

shared_context 'kyc_document_context' do
  include_context 'user_context'

  KYC_DOCUMENT_DATA ||= build_kyc_document
  KYC_DOCUMENT_PERSISTED ||= persist_kyc_doc KYC_DOCUMENT_DATA
end

def persist_kyc_doc(kyc_doc)
  MangoApi::KycDocuments.create kyc_doc, NATURAL_USER_PERSISTED.id
end

def build_kyc_document
  kyc_doc = MangoModel::KycDocument.new
  kyc_doc.type = MangoModel::KycDocumentType::IDENTITY_PROOF
  kyc_doc
end

def its_the_same_kyc_doc(kyc_doc1, kyc_doc2)
  kyc_doc1.type.eql?(kyc_doc2.type)
end