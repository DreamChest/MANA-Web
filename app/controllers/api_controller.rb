class ApiController < ApplicationController
	before_action :set_all, only: [:show]

	def show
		respond_to do |format|
			format.html { redirect_to root_url }
			format.json
		end
	end

	private
	# Set sources for API controller
	def set_all
		date = params["date"].present? ? params["date"] : Time.at(0)
		@entries = Entry.where("updated_at > ?", date)
		@sources = Source.where("updated_at > ?", date)
		@tags = Tag.where("updated_at > ?", date)
		@contents = Content.where("updated_at > ?", date)
	end
end
