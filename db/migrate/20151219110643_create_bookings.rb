class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :seller_id
      t.integer :buyer_id
      t.integer :room_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.integer :duration
      t.integer :guest
      t.monetize :subtotal
      t.monetize :service_fee
      t.monetize :total
      t.string :room_name
      t.string :room_title
      t.string :status, default: "Upcoming"
      t.boolean :paid, default: false
      t.datetime :check_in
      t.datetime :check_out
      t.date :start_date
      t.string :booking_code
      t.string :payment_method

      t.timestamps null: false
    end
    add_index :bookings, :seller_id
    add_index :bookings, :buyer_id
    add_index :bookings, :room_id
    add_index :bookings, :start_date
    add_index :bookings, :paid
    add_index :bookings, :payment_method
  end
end
