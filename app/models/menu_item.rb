class MenuItem < ActiveRecord::Base
  belongs_to :restaurant
  has_many :menu_item_tags
  has_many :tags, through: :menu_item_tags


  validates :name, presence: true
  validates :description, presence: true
  validates :menu_category, presence: true,
                            inclusion: {
                                         in: %w(Entree Appetizer Dessert Beverage Side),
                                         message: "must be either 'Entree', 'Appetizer', 'Dessert', 'Beverage', or 'Side'"
                                       }

end
