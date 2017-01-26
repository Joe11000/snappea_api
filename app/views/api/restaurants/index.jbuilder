return {} if @restaurants.blank?

json.restaurants @restaurants do |restaurant|
  json.(restaurant, :id , :name, :description)
  json.rating restaurant.rating.to_f
  json.(restaurant, :address)
end

json.prev 'prev_url_here' unless @page_index == 0
json.next 'next_url_here' unless @page_index >= @last_possible_page_index
