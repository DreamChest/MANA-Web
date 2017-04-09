class Source < ActiveRecord::Base
	# string name
	# string url
	# time last_updated
	
	has_many :entries, dependent: :destroy
	has_and_belongs_to_many :tags
	attr_accessor :tagslist_attr

	validates :name, :url, presence: true
	validates :url, url: true

	def tagslist
		str = ""

		self.tags.each do |t|
			str += "#{t.name},"
		end

		return str[0..-2]
	end
end
