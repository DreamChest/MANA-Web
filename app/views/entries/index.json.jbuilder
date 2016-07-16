json.array!(@entries) do |entry|
  json.extract! entry, :id, :source_id, :title, :url, :read, :fav, :date
end
