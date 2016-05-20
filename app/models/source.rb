class Source < ActiveRecord::Base
	# string name
	# string url
	
	has_many :entries, dependent: :destroy

	validates :name, :url, presence: true
end
