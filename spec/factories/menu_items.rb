FactoryGirl.define do
  factory :menu_item do
    sequence(:name) { |n| "menu_item #{n}" }
    description { Faker::Lorem.paragraph }
    menu_category { %w(Entree Appetizer Dessert Beverage Side).sample }
    restaurant
  end
end
