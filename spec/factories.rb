FactoryBot.define do
    factory :user do
      organisation_name { 'test4' }
      email { 'test4@email.com' }
      password { '123456' }
      password_confirmation { '123456' }
    end
  end