class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.integer :area_id

      t.timestamps null: false
    end
    add_index :rooms, :area_id
  end
end
