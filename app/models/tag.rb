class Tag < ActiveRecord::Base
  validates :name, uniqueness: true
  has_many :menu_item_tags
  has_many :menu_items, through: :menu_item_tags
end
