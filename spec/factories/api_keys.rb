FactoryGirl.define do
  factory :api_key do
    sequence(:guid) { Faker::Crypto.md5 }
  end
end
