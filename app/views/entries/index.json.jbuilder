json.array!(@entries) do |entry|
  json.extract! entry, :id, :title, :url, :fav
  json.url entry_url(entry, format: :json)
end
