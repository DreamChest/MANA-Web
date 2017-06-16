class AddHtmlUrlToSources < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :html_url, :string
  end
end
