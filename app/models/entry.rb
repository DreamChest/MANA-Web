class Entry < ApplicationRecord
	# string title
	# string url
	# boolean read
	# boolean fav
	# datetime date

	belongs_to :source
	has_one :content

	validates :title, :url, :date, :content, presence: true
end
