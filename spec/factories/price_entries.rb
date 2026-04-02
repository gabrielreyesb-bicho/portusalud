FactoryBot.define do
  factory :price_entry do
    association :drug
    association :pharmacy
    price_per_box { rand(50.0..500.0).round(2) }
    units_per_box { 30 }
    in_stock { true }
    home_delivery { false }
  end
end
