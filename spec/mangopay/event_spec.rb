describe MangoPay::Event do

  include_context 'payins'
  include_context 'payouts'

  describe 'FETCH' do

    it 'accepts filtering params' do

      # let's have at least 2 events
      payin = new_payin_card_direct
      create_new_payout_bankwire(payin)

      # get all # TODO: Uncomment this test once Events are fixed on the server
      # events = MangoPay::Event.fetch()
      # expect(events).to be_kind_of(Array)
      # expect(events.count).to be >= 2

      # only one per page # TODO: Uncomment this test once Events are fixed on the server
      # events = MangoPay::Event.fetch({'per_page' => 1})
      # expect(events).to be_kind_of(Array)
      # expect(events.count).to eq 1

      # filter by date
      events = MangoPay::Event.fetch({'AfterDate' => payin['CreationDate'], 'BeforeDate' => payin['CreationDate']})
      expect(events).to be_kind_of(Array)
      expect(events.count).to be >= 1
      expect(events.count { |e| e['ResourceId'] == payin['Id'] }).to be >= 1
    end
  end
end
