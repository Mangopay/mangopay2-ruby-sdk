shared_context 'address_context' do

  let(:address_data) { build_address }
end

def build_address
  address = MangoModel::Address.new
  address.address_line1 = 'Test st., no. 18'
  address.address_line2 = 'bl. 16, int. 32'
  address.city = 'Brasov'
  address.region = 'Tractoru'
  address.postal_code = '505600'
  address.country = MangoModel::CountryIso::RO
  address
end

def its_the_same_address(address1, address2)
  address1.address_line1 == address2.address_line1\
    && address1.address_line2 == address2.address_line2\
    && address1.city == address2.city\
    && address1.region == address2.region\
    && address1.region == address2.region\
    && address1.postal_code == address2.postal_code\
    && address1.country.eql?(address2.country)
end