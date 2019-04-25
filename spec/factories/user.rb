require 'faker'

FactoryBot.define do
  factory :user do
    organisation_name { Faker::Restaurant.name  }
    email { Faker::Internet.email }
    current_password = Faker::Internet.password(8)
    password { current_password }
    password_confirmation { current_password }
  end
end