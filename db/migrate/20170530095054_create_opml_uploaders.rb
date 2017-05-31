class CreateOpmlUploaders < ActiveRecord::Migration
  def change
    create_table :opml_uploaders do |t|

      t.timestamps null: false
    end
  end
end
