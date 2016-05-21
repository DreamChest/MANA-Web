class AddSourcesTagsJoinTable < ActiveRecord::Migration
  def self.up
	  create_table :sources_tags, :id => false do |t|
		  t.integer :source_id
		  t.integer :tag_id
	  end
  end
end
