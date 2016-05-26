json.array!(@sources) do |source|
  json.extract! source, :id, :name, :url, :last_update
  json.url source_url(source, format: :json)
end
