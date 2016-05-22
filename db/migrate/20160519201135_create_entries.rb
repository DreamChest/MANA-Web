class CreateEntries < ActiveRecord::Migration
	def change
		create_table :entries do |t|
			t.integer :source_id
			t.string :title
			t.string :url
			t.boolean :fav
			t.boolean :read
			t.datetime :date

			t.timestamps null: false
		end
	end
end
