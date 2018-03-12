require_relative '../context/hook_context'
require_relative '../../lib/mangopay/api/service/hooks'
require_relative '../../lib/mangopay/model/enum/hook_status'
require_relative '../../lib/mangopay/common/sort_field'
require_relative '../../lib/mangopay/common/sort_direction'

describe MangoApi::Hooks do
  include_context 'hook_context'


  describe '.create' do

    context 'given a valid object' do
      hook = HOOK_DATA

      it 'creates the hook entity' do
        expect { MangoApi::Hooks.create hook }.to raise_error(MangoPay::ResponseError, /already.+registered/)
      end
    end
  end

  describe '.update' do

    context 'given a valid object' do
      url = 'https://www.hello.com/hook'
      status = MangoModel::HookStatus::DISABLED
      created = HOOK_PERSISTED
      created.url = url
      created.status = status

      it 'updates the corresponding entity' do
        updated = MangoApi::Hooks.update created

        expect(updated).to be_kind_of MangoModel::Hook
        expect(updated.id).to eq created.id
        expect(updated.url).to eq url
        expect(updated.status).to be status
      end
    end
  end

  describe '.get' do

    context "given an existing entity's ID" do
      id = HOOK_PERSISTED.id

      it 'retrieves the corresponding entity' do
        retrieved = MangoApi::Hooks.get id

        expect(retrieved).to be_kind_of MangoModel::Hook
        expect(retrieved.id).to eq id
      end
    end
  end

  describe '.all' do

    context 'not having specified filters' do

      it 'retrieves list of all events' do
        results = MangoApi::Hooks.all

        expect(results).to be_kind_of Array
        results.each do |result|
          expect(result).to be_kind_of MangoModel::Hook
          expect(result.id).not_to be_nil
        end
      end
    end
  end
end