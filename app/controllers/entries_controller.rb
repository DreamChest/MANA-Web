class EntriesController < ApplicationController
	before_action :set_entry, only: [:show, :update, :destroy, :content]

	# GET /entries
	# GET /entries.json
	def index
		if params["tags"].present? # Filter entries by tag
			@entries = Entry.joins("inner join sources_tags on entries.source_id = sources_tags.source_id inner join tags on sources_tags.tag_id = tags.id").where("tags.name in (?)", params["tags"].split(','))
			@filter_type = "tags"
			@filter = params["tags"]
		elsif params["source"].present? # Filter entries by source
			@entries = Entry.joins(:source).where("sources.name=?", params["source"])
			@filter_type = "source"
			@filter = params["source"]
		else # No filter at all
			@entries = Entry.all
		end

		@entries = @entries.order("date DESC") # Sort entries by date

		@entries = @entries.where("date < ?", params["date"]) if params["date"].present? # Get entries older than a certain date only

		@entries = @entries.limit(ENTRIES_LIMIT) # Limit the result

		respond_to do |format|
			format.html
			format.json
		end
	end

	# GET /entries/1
	# GET /entries/1.json
	def show
		respond_to do |format|
			format.html { redirect_to root_path }
			format.json
		end
	end

	# POST /entries
	# POST /entries.json
	def create
		@entry = Entry.new(entry_params)

		respond_to do |format|
			if @entry.save
				format.html { redirect_to @entry, notice: I18n.t("notices.entry_created") }
				format.json { render :show, status: :created, location: @entry }
			else
				format.html { render :new }
				format.json { render json: @entry.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /entries/1
	# PATCH/PUT /entries/1.json
	def update
		respond_to do |format|
			if @entry.update(entry_params)
				format.html { redirect_to @entry, notice: I18n.t("notices.entry_updated") }
				format.json { render :show, status: :ok, location: @entry }
			else
				format.html { render :edit }
				format.json { render json: @entry.errors, status: :unprocessable_entity }
			end
		end
	end

	# GET /entries/1.json
	# Gets content (HTML article from the feed) from the entry
	def content
		respond_to do |format|
			format.html { redirect_to root_url }
			format.json
		end
	end


	# DELETE /entries/1
	# DELETE /entries/1.json
	def destroy
		@entry.destroy
		respond_to do |format|
			format.html { redirect_to entries_url, notice: I18n.t("notices.entry_destroyed") }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_entry
		@entry = Entry.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def entry_params
		params.require(:entry).permit(:title, :url, :read, :fav, :content)
	end
end
