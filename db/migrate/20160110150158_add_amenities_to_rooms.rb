class AddAmenitiesToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :restaurant, :boolean
    add_column :rooms, :bar, :boolean
    add_column :rooms, :balcony, :boolean
    add_column :rooms, :free_parking, :boolean
    add_column :rooms, :free_airport_shuttle, :boolean
    add_column :rooms, :free_wifi, :boolean
    add_column :rooms, :meeting_rooms, :boolean
    add_column :rooms, :outdoor_pool, :boolean
    add_column :rooms, :indoor_pool, :boolean
    add_column :rooms, :spa, :boolean
    add_column :rooms, :beauty_center, :boolean
    add_column :rooms, :fitness_room, :boolean
    add_column :rooms, :massage, :boolean
    add_column :rooms, :sauna, :boolean
    add_column :rooms, :jacuzzi, :boolean
    add_column :rooms, :kitchen, :boolean
    add_column :rooms, :title, :string
    add_index :rooms, :restaurant
    add_index :rooms, :bar
    add_index :rooms, :balcony
    add_index :rooms, :free_parking
    add_index :rooms, :free_airport_shuttle
    add_index :rooms, :free_wifi
    add_index :rooms, :meeting_rooms
    add_index :rooms, :outdoor_pool
    add_index :rooms, :indoor_pool
    add_index :rooms, :spa
    add_index :rooms, :beauty_center
    add_index :rooms, :fitness_room
    add_index :rooms, :massage
    add_index :rooms, :sauna
    add_index :rooms, :jacuzzi
    add_index :rooms, :kitchen
    add_index :rooms, :title
  end
end
