class AddPriceToRooms < ActiveRecord::Migration
  def change
    add_monetize :rooms, :price_per_three_hour #, currency: { present: false }
    add_monetize :rooms, :price_per_extra_hour
    add_monetize :rooms, :price_per_extra_guest
  end
end
