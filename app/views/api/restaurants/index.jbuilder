return {} if @restaurants.blank?

json.restaurants @restaurants do |restaurant|
  json.(restaurant, :id , :name, :description)
  json.rating restaurant.rating.to_f
  json.(restaurant, :address)
end

unless @page_index == 0
  json.prev headers["Host"] + '/api/restaurants?api_key=' + @api_key.guid + '&page=' + @page_index.to_s
end

unless @page_index >= @last_possible_page_index
  json.next headers["Host"] + '/api/restaurants?api_key=' + @api_key.guid + '&page=' + (@page_index + 2).to_s
end
