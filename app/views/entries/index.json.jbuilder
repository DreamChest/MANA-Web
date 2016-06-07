json.array!(@entries) do |entry|
  json.extract! entry, :id, :title, :url, :read, :fav, :date
end
