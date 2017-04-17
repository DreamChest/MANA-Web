class Source < ActiveRecord::Base
	# string name
	# string url
	# time last_updated
	
	has_many :entries, dependent: :destroy
	has_and_belongs_to_many :tags
	attr_accessor :tagslist_attr

	validates :name, :url, presence: true
	validates :url, url: true

	# Returns source tags list as a string
	def tagslist
		self.tags.map{|e| e.name}.join(',')
	end
end
