json.array!(@locations) do |location|
  json.extract! location, :id, :name, :currency, :currency_symbol
  json.url location_url(location, format: :json)
end
