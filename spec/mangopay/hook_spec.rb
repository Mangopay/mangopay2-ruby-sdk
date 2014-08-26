describe MangoPay::Hook do
  include_context 'hooks'

  describe 'CREATE' do
    it 'creates a hook' do
      expect(new_hook['Id']).to_not be_nil
    end
  end

  describe 'UPDATE' do
    it 'updates a hook' do
      new_url = new_hook['Url'] + '.com'
      updated_hook = MangoPay::Hook.update(new_hook['Id'], {
        Url: new_url,
        Tag: 'Updated Tag'
      })
    expect(updated_hook['Url']).to eq(new_url)
      expect(updated_hook['Tag']).to eq('Updated Tag')
    end
  end

  describe 'FETCH' do

    it 'fetches a hook' do
      hook = MangoPay::Hook.fetch(new_hook['Id'])
      expect(hook['Id']).to eq(new_hook['Id'])
    end

    it 'fetches all the hooks' do
      hooks = MangoPay::Hook.fetch()
      expect(hooks).to be_kind_of(Array)
      expect(hooks).not_to be_empty
    end

  end

end
