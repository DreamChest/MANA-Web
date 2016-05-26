json.array!(@entries) do |entry|
  json.extract! entry, :id, :title, :url, :read, :fav, :date
  json.url entry_url(entry, format: :json)
end
