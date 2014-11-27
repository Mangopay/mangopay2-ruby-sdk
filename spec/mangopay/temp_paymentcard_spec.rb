describe MangoPay::Temp::PaymentCard do
  include_context 'users'

  def new_temp_paymentcard
    MangoPay::Temp::PaymentCard.create({
      Tag: 'Test temp payment card',
      UserId: new_natural_user['Id'],
      Culture: 'FR',
      ReturnURL: 'https://mysite.com/return',
      TemplateURL: 'https://mysite.com/template'
    })
  end

  describe 'CREATE' do
    it 'creates a temp payment card' do
      created = new_temp_paymentcard
      expect(created['Id']).to_not be_nil
      expect(created['UserId']).to eq(new_natural_user['Id'])
    end
  end

  describe 'FETCH' do
    it 'fetches a temp payment card' do
      created = new_temp_paymentcard
      fetched = MangoPay::Temp::PaymentCard.fetch(created['Id'])
      expect(fetched['Id']).to eq(created['Id'])
      expect(fetched['UserId']).to eq(created['UserId'])
    end
  end

end
