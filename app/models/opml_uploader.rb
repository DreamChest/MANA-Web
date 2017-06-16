class OpmlUploader < ApplicationRecord
	has_attached_file :file
	validates_attachment :file,
		presence: true,
		content_type: { content_type: [
			"application/xml",
			"text/xml",
			"text/x-opml",
			"text/x-opml+xml"
		]}
end
