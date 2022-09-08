describe MangoPay::Regulatory do

  describe 'GET Country Authorizations' do
    it 'can get country authorizations' do
      country_authorizations = MangoPay::Regulatory.get_country_authorizations('FR')

      expect(country_authorizations).not_to be_nil
      expect(country_authorizations['CountryCode']).not_to be_nil
      expect(country_authorizations['CountryName']).not_to be_nil
      expect(country_authorizations['Authorization']).not_to be_nil
      expect(country_authorizations['LastUpdate']).not_to be_nil
    end
  end

  describe 'GET All Countries Authorizations' do
    it 'can get all countries authorizations' do
      country_authorizations = MangoPay::Regulatory.get_all_countries_authorizations

      expect(country_authorizations).not_to be_nil
      expect(country_authorizations[0]['CountryCode']).not_to be_nil
      expect(country_authorizations[0]['CountryName']).not_to be_nil
      expect(country_authorizations[0]['Authorization']).not_to be_nil
      expect(country_authorizations[0]['LastUpdate']).not_to be_nil
    end
  end
end
