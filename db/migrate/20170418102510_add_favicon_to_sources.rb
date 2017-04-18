class AddFaviconToSources < ActiveRecord::Migration
  def change
    add_column :sources, :favicon, :string
  end
end
