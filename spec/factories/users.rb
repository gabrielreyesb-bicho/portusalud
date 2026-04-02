FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
