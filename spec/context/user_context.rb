require_relative 'address_context'

shared_context 'user_context' do
  include_context 'address_context'

  NATURAL_USER_DATA ||= build_natural_user
  LEGAL_USER_DATA ||= build_legal_user
  NATURAL_USER_PERSISTED ||= persist_user NATURAL_USER_DATA
  LEGAL_USER_PERSISTED ||= persist_user LEGAL_USER_DATA

  let(:new_natural_user_persisted) { persist_user NATURAL_USER_DATA }
  let(:new_legal_user_persisted) { persist_user LEGAL_USER_DATA }
end

def persist_user(user)
  MangoApi::Users.create user
end

def build_natural_user
  nat_user = MangoModel::NaturalUser.new
  nat_user.kyc_level = MangoModel::KycLevel::LIGHT
  nat_user.email = 'hello@moto.com'
  nat_user.first_name = 'Hi'
  nat_user.last_name = 'Bye'
  nat_user.address = build_address
  nat_user.birthday = 105_102_394
  nat_user.nationality = MangoModel::CountryIso::RO
  nat_user.country_of_residence = MangoModel::CountryIso::RO
  nat_user.occupation = 'Cowboy'
  nat_user.income_range = MangoModel::IncomeRange::BETWEEN_50_80
  nat_user
end

def build_legal_user
  leg_user = MangoModel::LegalUser.new
  leg_user.email = 'coco@coco.com'
  leg_user.legal_person_type = MangoModel::LegalPersonType::BUSINESS
  leg_user.name = 'Coco Company'
  leg_user.headquarters_address = build_address
  leg_user.legal_representative_first_name = 'Bob'
  leg_user.legal_representative_last_name = 'Business'
  leg_user.legal_representative_address = build_address
  leg_user.legal_representative_email = 'bobby@coco.com'
  leg_user.legal_representative_birthday = 1_300_116_382
  leg_user.legal_representative_nationality = MangoModel::CountryIso::DE
  leg_user.legal_representative_country_of_residence = MangoModel::CountryIso::RO
  leg_user
end

def its_the_same_user(user1, user2)
  if user1.is_a? MangoModel::NaturalUser
    its_the_same_natural(user1, user2)
  else
    its_the_same_legal(user1, user2)
  end
end

def its_the_same_natural(user1, user2)
  user1.kyc_level.eql?(user2.kyc_level)\
    && user1.email == user2.email\
    && user1.first_name == user2.first_name\
    && user1.last_name == user2.last_name\
    && its_the_same_address(user1.address, user2.address)\
    && user1.birthday == user2.birthday\
    && user1.nationality.eql?(user2.nationality)\
    && user1.country_of_residence.eql?(user2.country_of_residence)\
    && user1.occupation == user2.occupation\
    && user1.income_range == user2.income_range
end

def its_the_same_legal(user1, user2)
  user1.email == user2.email\
    && user1.legal_person_type.eql?(user2.legal_person_type)\
    && user1.name == user2.name\
    && its_the_same_address(user1.headquarters_address, user2.headquarters_address)\
    && user1.legal_representative_first_name == user2.legal_representative_first_name\
    && user1.legal_representative_last_name == user2.legal_representative_last_name\
    && its_the_same_address(user1.legal_representative_address, user2.legal_representative_address)\
    && user1.legal_representative_email == user2.legal_representative_email\
    && user1.legal_representative_birthday == user2.legal_representative_birthday\
    && user1.legal_representative_nationality == user2.legal_representative_nationality\
    && user1.legal_representative_country_of_residence.eql?(user2.legal_representative_country_of_residence)
end