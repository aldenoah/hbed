class ChangeBookingStartEndFormatForRooms < ActiveRecord::Migration
  def up
    remove_column :rooms, :booking_start
    remove_column :rooms, :booking_end
  end
end
