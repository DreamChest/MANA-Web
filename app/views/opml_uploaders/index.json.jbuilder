json.array!(@opml_uploaders) do |opml_uploader|
  json.extract! opml_uploader, :id
  json.url opml_uploader_url(opml_uploader, format: :json)
end
