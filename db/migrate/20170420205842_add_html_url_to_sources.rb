class AddHtmlUrlToSources < ActiveRecord::Migration
  def change
    add_column :sources, :html_url, :string
  end
end
