class CreateOpmlUploaders < ActiveRecord::Migration[5.1]
  def change
    create_table :opml_uploaders do |t|

      t.timestamps null: false
    end
  end
end
