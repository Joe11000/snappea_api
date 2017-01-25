FactoryGirl.define do
  factory :restaurant do
    sequence(:name) { |n| "restaurant #{n}" }
    description { Faker::Lorem.paragraph }
    rating { (rand(50) / 10.0).to_f }
    address { Faker::Address.street_address }
  end
end
