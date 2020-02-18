require_relative '../../lib/mangopay/model/birthplace'

shared_context 'birthplace_context' do
  let(:birthplace_data) { build_birthplace }
end

def build_birthplace
  birthplace = MangoModel::Birthplace.new
  birthplace.city = 'Brasov'
  birthplace.country = MangoModel::CountryIso::RO
  birthplace
end

def its_the_same_birthplace(birthplace1, birthplace2)
  birthplace1.city == birthplace2.city\
        && birthplace1.country.eql?(birthplace2.country)
end
