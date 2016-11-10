require 'rails_helper'

RSpec.describe MembershipApplication, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(FactoryGirl.create(:membership_application)).to be_valid
    end
  end

  describe 'DB Table' do
    it {is_expected.to have_db_column :id}
    it {is_expected.to have_db_column :company_name}
    it {is_expected.to have_db_column :company_number}
    it {is_expected.to have_db_column :contact_person}
    it {is_expected.to have_db_column :phone_number}
    it {is_expected.to have_db_column :company_email}


  end
end
