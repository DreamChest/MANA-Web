class Tag < ActiveRecord::Base
	# string name
	# string color
	
	has_and_belongs_to_many :sources
	
	validates :name, :color, presence: true
end
