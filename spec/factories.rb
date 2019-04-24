FactoryBot.define do
    factory :user do
      organisation_name { 'test2' }
      email { 'test2@email.com' }
      password { '123456' }
      password_confirmation { '123456' }
    end
  end