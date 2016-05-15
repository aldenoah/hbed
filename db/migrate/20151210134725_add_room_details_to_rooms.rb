class AddRoomDetailsToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :booking_start, :time
    add_column :rooms, :booking_end, :time
    add_column :rooms, :active, :boolean, default: false
    add_column :rooms, :location, :string
    add_column :rooms, :latitude, :float
    add_column :rooms, :longitude, :float
    add_column :rooms, :district, :string
  end
end
