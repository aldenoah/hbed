class AddDirectionToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :direction, :text
    add_column :rooms, :user_id, :integer
    add_index :rooms, :user_id
    add_monetize :rooms, :deposit
    add_column :rooms, :room_type, :string
  end
end
