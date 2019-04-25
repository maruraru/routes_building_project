require 'rails_helper'

RSpec.describe User, type: :model do
  user_data = FactoryBot.build(:user)

  context 'all fields are filled correctly' do
    it 'is valid with valid attributes' do
      user = described_class.new
      user.email = user_data.email
      user.organisation_name = user_data.organisation_name
      user.password = user_data.password
      user.password_confirmation = user_data.password_confirmation
      expect(user).to be_valid
    end
  end

  context 'some fields sre incorrect' do
    it "isn't valid w/o org name" do
      user = described_class.new
      user.email = user_data.email
      user.organisation_name = ''
      user.password = user_data.password
      user.password_confirmation = user_data.password_confirmation
      expect(user).to_not be_valid
    end

    it "isn't valid w/o email" do
      user = described_class.new
      user.email = ''
      user.organisation_name = user_data.organisation_name
      user.password = user_data.password
      user.password_confirmation = user_data.password_confirmation
      expect(user).to_not be_valid
    end

    it "isn't valid w/o password" do
      user = described_class.new
      user.email = user_data.email
      user.organisation_name = user_data.organisation_name
      user.password = ''
      user.password_confirmation = user_data.password_confirmation
      expect(user).to_not be_valid
    end

    it "isn't valid w/o password confirmation" do
      user = described_class.new
      user.email = user_data.email
      user.organisation_name = user_data.organisation_name
      user.password = user_data.password
      user.password_confirmation = ''
      expect(user).to_not be_valid
    end
  end
end
