class AddFaviconToSources < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :favicon, :string
  end
end
