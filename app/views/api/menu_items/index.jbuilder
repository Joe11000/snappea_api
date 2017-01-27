return {} if @restaurant.blank?

json.restaurant @restaurant.name


if @restaurant.menu_items.length == 0
  json.menu_items {}
else
  json.menu_items @restaurant.menu_items do |menu_item|
    json.(menu_item, :id, :name, :description, :menu_category)

    json.tags menu_item.tags.pluck(:name)
  end
end
