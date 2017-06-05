json.entries @entries, :id, :source_id, :title, :url, :fav, :read, :date, :created_at, :updated_at
json.sources @sources do |s|
	json.extract! s, :id, :name, :url, :favicon, :html_url, :created_at, :updated_at
	json.tags @tags, :id
end
json.tags @tags, :id, :name, :color, :created_at, :updated_at
