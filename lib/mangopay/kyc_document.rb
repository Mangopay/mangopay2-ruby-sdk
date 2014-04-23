require 'base64'

module MangoPay
  class KycDocument < Resource

    def self.create(user_id, params)
      MangoPay.request(:post, url(user_id), params)
    end

    def self.update(user_id, document_id, params = {})
      MangoPay.request(:put, url(user_id, document_id), params)
    end

    def self.fetch(user_id, document_id)
      MangoPay.request(:get, url(user_id, document_id))
    end

    # Adds the file page (attachment) to the given document.
    # 
    # See http://docs.mangopay.com/api-references/kyc/pages/ :
    # - Document have to be in 'CREATED' Status
    # - You can create as many pages as needed
    # - Change Status to 'VALIDATION_ASKED' to submit KYC documents
    # 
    # The file_or_base64 param may be:
    # - either a File instance
    # - or a string: in this case it has to be Base64 encoded!
    #
    def self.create_page(user_id, document_id, file_or_base64)
      base64 = (file_or_base64.is_a? File) ? Base64.encode64(file_or_base64.read) : file_or_base64;
      # normally it returns 204 HTTP code on success
      begin
        MangoPay.request(:post, url(user_id, document_id) + '/pages', {'File' => base64})
      rescue MangoPay::ResponseError => ex
        raise ex unless ex.code == '204'
      end
    end

    def self.url(user_id, document_id = nil)
      if document_id
        "/v2/#{MangoPay.configuration.client_id}/users/#{CGI.escape(user_id.to_s)}/KYC/documents/#{CGI.escape(document_id.to_s)}"
      else
        "/v2/#{MangoPay.configuration.client_id}/users/#{CGI.escape(user_id.to_s)}/KYC/documents"
      end
    end
  end
end
