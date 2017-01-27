class Tag < ActiveRecord::Base
  has_many :menu_item_tags
  has_many :menu_items, through: :menu_item_tags

  validates :name, uniqueness: true
end
