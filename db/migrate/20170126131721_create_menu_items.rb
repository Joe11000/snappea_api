class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.string :menu_category
      t.references :restaurant, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :menu_items, :name
  end
end
