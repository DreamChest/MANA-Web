class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :url
	  t.datetime :last_update

      t.timestamps null: false
    end
  end
end
