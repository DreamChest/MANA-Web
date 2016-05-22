class Entry < ActiveRecord::Base
	# string title
	# string url
	# boolean fav

	belongs_to :source
	has_one :content

	validates :title, :url, presence: true
end
