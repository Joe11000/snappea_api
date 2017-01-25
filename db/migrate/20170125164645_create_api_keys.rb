class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :guid, limit: 32

      t.timestamps null: false
    end
  end
end
