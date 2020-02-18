require_relative '../../lib/mangopay/api/service/ubo_declarations'
require_relative '../context/ubo_declaration_context'
require_relative '../../lib/mangopay/model/enum/ubo_declaration_status'

describe MangoApi::UboDeclarations do
  include_context 'ubo_declaration_context'

  LEGAL_USER = persist_user(build_legal_user)
  UBO_DECLARATION = persist_ubo_declaration(LEGAL_USER.id)
  UBO = persist_ubo(LEGAL_USER.id, UBO_DECLARATION.id)

  describe '.create_ubo_declarations' do

    context 'given a valid user' do
      it 'creates the UBO declaration entity' do
        created = UBO_DECLARATION

        expect(created).to be_kind_of MangoModel::UboDeclaration
        expect(created.status).to be MangoModel::UboDeclarationStatus::CREATED
        expect(created.id).not_to be_nil
      end
    end
  end

  describe '.all' do

    context 'get all ubo declarations' do
      user = LEGAL_USER
      created = UBO_DECLARATION
      it 'get all ubo declarations' do
        list = MangoApi::UboDeclarations.get_all(user.id)

        expect(list).to be_kind_of Array
        expect(list.length).to eq 1
        expect(list[0]).to be_kind_of MangoModel::UboDeclaration
        expect(list[0].id).to eq created.id

      end
    end
  end

  describe '.get one ubo declaration' do
    context 'get an ubo declaration' do
      user = LEGAL_USER
      ubo_declaration = UBO_DECLARATION
      it 'retrieves an ubo declaration with and without user id' do
        response1 = MangoApi::UboDeclarations.get(user.id, ubo_declaration.id)
        response2 = MangoApi::UboDeclarations.get(nil, ubo_declaration.id)

        expect(response1).to be_kind_of MangoModel::UboDeclaration
        expect(response1.id).to eq ubo_declaration.id
        expect(response2).to be_kind_of MangoModel::UboDeclaration
        expect(response2.id).to eq ubo_declaration.id
        expect(response1.id).to eq response2.id
      end
    end
  end

  describe '.create ubo' do

    context 'given an existing ubo declarations' do
      ubo_declaration = UBO_DECLARATION
      user = LEGAL_USER

      it 'add ubo to the corresponding ubo declaration' do
        ubo = build_ubo
        response = MangoApi::UboDeclarations.create_ubo(user.id, ubo_declaration.id, ubo)

        expect(response).to be_kind_of MangoModel::Ubo
      end
    end
  end

  describe '.get ubo' do
    context 'given an existing ubo' do
      user = LEGAL_USER
      ubo_declaration = UBO_DECLARATION
      ubo = UBO
      it 'should retrieve an ubo by his id' do
        response = MangoApi::UboDeclarations.get_ubo(user.id, ubo_declaration.id, ubo.id)

        expect(response).to be_kind_of MangoModel::Ubo
        expect(response.id).to eq ubo.id
      end
    end
  end

  describe '.update ubo' do

    context 'given an existing ubo declaration' do
      ubo_declaration = UBO_DECLARATION
      user = LEGAL_USER
      ubo = UBO
      it 'should update the ubo' do
        ubo.first_name = "updated_first_name"
        ubo.last_name = "updated_last_name"
        ubo.nationality = MangoModel::CountryIso::GB
        ubo.is_active = true

        updated_ubo = MangoApi::UboDeclarations.update_ubo(user.id, ubo_declaration.id, ubo)

        expect(updated_ubo).to be_kind_of MangoModel::Ubo
        expect(updated_ubo.id).to eq ubo.id
        expect(updated_ubo.first_name).to eq ubo.first_name
        expect(updated_ubo.last_name).to eq ubo.last_name
        expect(updated_ubo.nationality).to eq ubo.nationality
        expect(updated_ubo.is_active).to eq true
      end
    end
  end

  describe '.submit' do

    context "given an existing entity's ID" do
      created = UBO_DECLARATION
      user = LEGAL_USER
      id = created.id

      it 'submits the corresponding entity for approval' do
        submitted = MangoApi::UboDeclarations.submit user.id, id

        expect(submitted).to be_kind_of MangoModel::UboDeclaration
        expect(submitted.id).to eq id
        expect(submitted.status).to be MangoModel::UboDeclarationStatus::VALIDATION_ASKED
      end
    end
  end
end