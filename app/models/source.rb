class Source < ActiveRecord::Base
	# string name
	# string url
	
	has_many :entries, dependent: :destroy
	has_and_belongs_to_many :tags

	validates :name, :url, presence: true
end
