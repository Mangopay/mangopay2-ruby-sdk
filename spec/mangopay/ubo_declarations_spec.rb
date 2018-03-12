require_relative '../../lib/mangopay/api/service/ubo_declarations'
require_relative '../context/ubo_declaration_context'
require_relative '../../lib/mangopay/model/enum/ubo_declaration_status'

describe MangoApi::UboDeclarations do
  include_context 'ubo_declaration_context'

  describe '.create' do

    context 'given a valid object' do
      ubo_decl = UBO_DECLARATION_DATA

      it 'creates the UBO declaration entity' do
        created = MangoApi::UboDeclarations.create(ubo_decl, LEGAL_USER_PERSISTED.id)

        expect(created).to be_kind_of MangoModel::UboDeclaration
        expect(created.status).to be MangoModel::UboDeclarationStatus::CREATED
        expect(created.user_id).to eq LEGAL_USER_PERSISTED.id
        created.declared_ubos.each do |ubo|
          expect(ubo).to be_kind_of MangoModel::DeclaredUbo
          expect(ubo.status).to be MangoModel::DeclaredUboStatus::CREATED
        end
      end
    end
  end

  describe '.update' do

    context 'given a valid object' do
      created = UBO_DECLARATION_PERSISTED
      natural_user = NATURAL_USER_DATA
      natural_user.capacity = MangoModel::NaturalUserCapacity::DECLARATIVE
      decl_user = MangoApi::Users.create natural_user
      created.declared_ubos = [decl_user.id]

      it 'updates the corresponding entity' do
        updated = MangoApi::UboDeclarations.update created

        expect(updated).to be_kind_of MangoModel::UboDeclaration
        expect(updated.id).to eq created.id
        expect(updated.declared_ubos.length).to eq created.declared_ubos.length
        updated.declared_ubos.each do |ubo|
          expect(ubo).to be_kind_of MangoModel::DeclaredUbo
          expect(created.declared_ubos).to include ubo.user_id
        end
      end
    end
  end

  describe '.submit' do

    context "given an existing entity's ID" do
      created = UBO_DECLARATION_PERSISTED
      id = created.id

      it 'submits the corresponding entity for approval' do
        submitted = MangoApi::UboDeclarations.submit id

        expect(submitted).to be_kind_of MangoModel::UboDeclaration
        expect(submitted.id).to eq id
        expect(submitted.status).to be MangoModel::UboDeclarationStatus::VALIDATION_ASKED
      end
    end
  end
end