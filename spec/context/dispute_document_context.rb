require_relative 'dispute_context'
require_relative '../../lib/mangopay/model/entity/dispute_document'
require_relative '../../lib/mangopay/model/enum/dispute_document_type'

shared_context 'dispute_document_context' do
  include_context 'dispute_context'

  DISPUTE_DOCUMENT_DATA ||= build_dispute_document
  DISPUTE_DOCUMENT_PERSISTED ||= persisted_dispute_doc
end

def persisted_dispute_doc
  MangoApi::DisputeDocuments.all[0]
end

def build_dispute_document
  document = MangoModel::DisputeDocument.new
  document.type = MangoModel::DisputeDocumentType::REFUND_PROOF
  document
end