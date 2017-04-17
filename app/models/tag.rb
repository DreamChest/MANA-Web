class Tag < ActiveRecord::Base
	# string name
	# string color
	
	has_and_belongs_to_many :sources
	
	validates :name, :color, presence: true

	# Returns all tags list as a string
	def self.list
		Tag.all.map{|e| e.name}.join(',')
	end

	# Returns tag sources list as a string
	def sourceslist
		self.sources.map{|e| e.name}.join(',')
	end

	# Returns wether or not a tag has sources
	def has_sources
		return not(self.sources.empty?)
	end

	# Define html attributes to use on index page if the tag has no sources
	def no_sources_html_attr
		return self.has_sources ? {} : {class: "warning", data: { toggle: "tooltip" }, title: I18n.t("tooltips.unused_tag")}
	end
end
