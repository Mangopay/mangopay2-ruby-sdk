require_relative '../context/pre_authorization_context'
require_relative '../context/pre_authorization_context'
require_relative '../../lib/mangopay/api/service/pre_authorizations'
require_relative '../../lib/mangopay/model/enum/payment_status'

describe MangoApi::PreAuthorizations do
  include_context 'pre_authorization_context'

  describe '.create' do

    context 'given a valid object' do
      pre_auth = PRE_AUTHORIZATION_DATA

      it 'creates the pre-authorization entity' do
        created = MangoApi::PreAuthorizations.create pre_auth

        expect(created).to be_kind_of MangoModel::PreAuthorization
        expect(created.id).not_to be_nil
        expect(created.payment_status).to be MangoModel::PaymentStatus::WAITING
        expect(its_the_same_pre_auth(pre_auth, created)).to be_truthy
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      pre_auth = PRE_AUTHORIZATION_PERSISTED
      id = pre_auth.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::PreAuthorizations.get id

        expect(retrieved).to be_kind_of MangoModel::PreAuthorization
        expect(retrieved.id).to eq id
        expect(its_the_same_pre_auth(pre_auth, retrieved)).to be_truthy
      end
    end
  end

  describe '.cancel' do

    context "given an existing entity's ID" do
      it 'cancels the corresponding entity' do
        # noinspection RubyResolve
        pre_auth = new_pre_authorization_persisted
        id = pre_auth.id
        canceled = MangoApi::PreAuthorizations.cancel id

        expect(canceled).to be_kind_of MangoModel::PreAuthorization
        expect(canceled.id).to eq id
        expect(canceled.status).to be MangoModel::PreAuthorizationStatus::SUCCEEDED
        expect(canceled.payment_status).to be MangoModel::PaymentStatus::CANCELED
        expect(its_the_same_pre_auth(pre_auth, canceled)).to be_truthy
      end
    end
  end
end