FactoryBot.define do
  factory :pharmacy do
    name { Faker::Company.name }
    kind { "cadena" }
  end
end
