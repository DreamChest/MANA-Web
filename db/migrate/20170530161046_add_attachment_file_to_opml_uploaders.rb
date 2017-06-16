class AddAttachmentFileToOpmlUploaders < ActiveRecord::Migration[5.1]
  def self.up
    change_table :opml_uploaders do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :opml_uploaders, :file
  end
end
