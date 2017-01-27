api_key = FactoryGirl.create(:api_key)

puts
puts "restaurants index api endpoint -> localhost:3000/api/restaurants?api_key=#{api_key.guid}&page=1"

num = 25

num.times do
  FactoryGirl.create(:menu_item_tag)
end

for i in 1..25 do
  if i % num != 0
    MenuItem.find(i).tags << Tag.find(i + 1)
  else
    MenuItem.last.tags << Tag.first
  end
end

puts
puts "menu_items index api endpoint -> localhost:3000/api/restaurants/#{Restaurant.first.id}/menu_items?api_key=#{api_key.guid}"
