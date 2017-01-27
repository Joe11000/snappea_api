class CreateMenuItemTags < ActiveRecord::Migration
  def change
    create_table :menu_item_tags do |t|
      t.references :menu_item, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
