json.array!(@sources) do |source|
  json.extract! source, :id, :name, :url, :tags, :last_update
end
