# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

api_key = FactoryGirl.create(:api_key)
puts "api endpoint = localhost:3000/api/restaurants?api_key=#{api_key.guid}&page=1"

25.times do
  FactoryGirl.create(:restaurant)
end
