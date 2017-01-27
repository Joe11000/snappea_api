return {} if @restaurant.blank?

json.restaurant @restaurant

debugger

json.menu_items @restaurant.menu_items do |menu_item|
  json.(@menu_items, :id, :name, :description, :menu_category)
end
