FactoryBot.define do
  factory :drug do
    name { Faker::Lorem.word.capitalize }
    active_ingredient { Faker::Lorem.word.downcase }
    form { "tableta" }
    dosage { "#{rand(100..1000)}mg" }
    requires_prescription { false }
    therapeutic_group { "Antidiabéticos" }
    via { "oral" }
    slug { "#{name.downcase}-#{dosage.downcase}".gsub(/\s+/, "-") }
  end
end
