class Entry < ActiveRecord::Base
	# string title
	# string url
	# boolean fav

	belongs_to :source

	validates :title, :url, presence: true
end
