class SourcesController < ApplicationController
	require "feedjira"

	before_action :set_source, only: [:show, :edit, :update, :destroy, :show_entries, :update_entries]

	# GET /sources
	# GET /sources.json
	def index
		@sources = Source.all
	end

	# GET /sources/1
	# GET /sources/1.json
	def show
	end

	# GET /sources/new
	def new
		@source = Source.new
		@entries = @source.entries.build
		@tags = @source.tags.build
	end

	# GET /sources/1/edit
	def edit
	end

	# POST /sources
	# POST /sources.json
	def create
		@source = Source.new(source_params)

		feed = Feedjira::Feed.fetch_and_parse(@source.url) if @source.valid?

		respond_to do |format|
			if @source.save
				tag

				feed.entries.reverse.each do |e|
					@entry = @source.entries.create!(title: e.title, url: e.url, read: false, fav: false, date: e.published, content: Content.create({ html: e.content }))
				end

				@source.update(last_update: feed.entries.first.published)

				format.html { redirect_to @source, notice: 'Source was successfully created.' }
				format.json { render :show, status: :created, location: @source }
			else
				format.html { render :new }
				format.json { render json: @source.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /sources/1
	# PATCH/PUT /sources/1.json
	def update
		@source.assign_attributes(source_params)

		feed = Feedjira::Feed.fetch_and_parse(@source.url) if @source.valid? and @source.url_changed?

		respond_to do |format|
			if @source.update(source_params)
				@source.tags.clear
				tag

				unless feed.nil?
					@source.entries.clear
					feed.entries.reverse.each do |e|
						@entry = @source.entries.create!(title: e.title, url: e.url, read: false, fav: false, date: e.published, content: Content.create({ html: e.content || e.summary }))
					end

					@source.update(last_update: feed.entries.first.published)
				end

				format.html { redirect_to @source, notice: 'Source was successfully updated.' }
				format.json { render :show, status: :ok, location: @source }
			else
				format.html { render :edit }
				format.json { render json: @source.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /sources/1
	# DELETE /sources/1.json
	def destroy
		@source.destroy
		respond_to do |format|
			format.html { redirect_to sources_url, notice: 'Source was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	# Shows entries for the source
	def show_entries
		render :partial => "entries/entries", locals: { entries: @source.entries }
	end

	def update_entries
		feed = Feedjira::Feed.fetch_and_parse(@source.url)

		feed.entries.reverse.each do |e|
			if e.published > @source.last_update
				@source.entries.create!(title: e.title, url: e.url, read: false, fav: false, date: e.published, content: Content.create({ html: e.content || e.summary }))
			end
		end

		@source.update(last_update: feed.entries.first.published)

		redirect_to :back
	end

	private
	# Tags the source
	def tag
		params[:source]["tagslist_attr"].split(',').each do |t|
			tag = Tag.where("name = '#{t}'").take
			if tag.nil?
				@source.tags.create!(name: t, color: "#ffffff")
			else
				@source.tags<<(tag)
			end
		end
	end

	# Use callbacks to share common setup or constraints between actions.
	def set_source
		@source = Source.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def source_params
		params.require(:source).permit(:name, :url, :tagslist_attr)
	end
end
