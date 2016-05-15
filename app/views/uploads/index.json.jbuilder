json.array!(@uploads) do |upload|
  json.extract! upload, :id, :room_id
  json.url upload_url(upload, format: :json)
end
