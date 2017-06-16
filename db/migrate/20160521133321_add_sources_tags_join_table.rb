class AddSourcesTagsJoinTable < ActiveRecord::Migration[5.1]
  def self.up
	  create_table :sources_tags, :id => false do |t|
		  t.integer :source_id
		  t.integer :tag_id
	  end
  end
end
