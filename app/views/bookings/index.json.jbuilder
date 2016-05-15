json.array!(@bookings) do |booking|
  json.extract! booking, :id, :seller_id, :buyer_id, :duration, :unit_price, :subtotal, :service_fee, :total, :name
  json.url booking_url(booking, format: :json)
end
