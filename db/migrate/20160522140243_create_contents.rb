class CreateContents < ActiveRecord::Migration[5.1]
	def change
		create_table :contents do |t|
			t.integer :entry_id
			t.text :html

			t.timestamps null: false
		end
	end
end
