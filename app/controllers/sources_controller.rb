class SourcesController < ApplicationController
	require "feedjira"

	before_action :set_source, only: [:show, :edit, :update, :destroy, :show_entries, :update_entries]
	before_action :set_sources, only: [:index, :create, :update, :update_entries]

	# GET /sources
	# GET /sources.json
	def index
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

		begin
			feed = Feedjira::Feed.fetch_and_parse(@source.url) if @source.valid?

			respond_to do |format|
				if @source.save
					tag

					feed.entries.reverse.each do |e|
						@source.entries.create!(title: e.title, url: e.url, read: false, fav: false, date: e.published, content: Content.create({ html: e.content || e.summary }))
					end

					@source.update(last_update: feed.entries.first.published)

					format.html { render :index }
					format.json {
						flash[:notice] = I18n.t("notices.source_created")
						render :show, status: :created, location: @source
					}
				else
					format.html { render :new }
					format.json { render json: @source.errors, status: :unprocessable_entity }
				end
			end
		rescue
			respond_to do |format|
				format.html { render :new }
				format.json { render json: { url: [I18n.t("errors.invalid_feed")] }, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /sources/1
	# PATCH/PUT /sources/1.json
	def update
		@source.assign_attributes(source_params)

		begin
			feed = Feedjira::Feed.fetch_and_parse(@source.url) if @source.valid? and @source.url_changed?

			respond_to do |format|
				if @source.update(source_params)
					@source.tags.clear
					tag

					unless feed.nil?
						@source.entries.clear
						feed.entries.reverse.each do |e|
							@source.entries.create!(title: e.title, url: e.url, read: false, fav: false, date: e.published, content: Content.create({ html: e.content || e.summary }))
						end

						@source.update(last_update: feed.entries.first.published)
					end

					format.html { render :index }
					format.json {
						flash[:notice] = I18n.t("notices.source_updated", count: 1)
						render :show, status: :ok, location: @source
					}
				else
					format.html { render :edit }
					format.json { render json: @source.errors, status: :unprocessable_entity }
				end
			end
		rescue
			respond_to do |format|
				format.html { render :new }
				format.json { render json: { url: [I18n.t("errors.invalid_feed")] }, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /sources/1
	# DELETE /sources/1.json
	def destroy
		@source.destroy
		respond_to do |format|
			format.html {
				@sources = Source.all
				flash.now[:notice] = I18n.t("notices.source_destroyed")
				render :index
			}
			format.json { head :no_content }
		end
	end

	# Shows entries for the source
	def show_entries
		respond_to do |format|
			format.html { render :partial => "entries", locals: { entries: @source.entries } }
			format.json { render json: @source.entries }
		end
	end

	# Updates entries for the source
	def update_entries
		begin
			fetch

			flash.now[:notice] = I18n.t("notices.source_updated", count: 1)
			render :index
		rescue
			flash.now[:error] = I18n.t("errors.invalid_feed")
			render :index
		end
	end

	# Updates all sources (fetches entries for each source)
	def update_all
		last_entry = Entry.order("date DESC").first # Get most recent entry date
		failed_sources = []

		Source.all.each do |s|
			@source = s
			begin
				fetch
			rescue
				failed_sources.push(@source.name)
			end
		end

		if last_entry.nil? # If no entries where present before (first update)...
			new_entries = Entry.order("date DESC") # ... then all entries are kept and considered new
		else
			new_entries = Entry.where("date > ?", last_entry.date).order("date DESC") # ... else, only more recent entries are kept and considered new
		end

		if new_entries.empty? # If there are no new entries...
			@entries = Entry.order("date DESC").limit(ENTRIES_LIMIT) # ... then display entries normally
		else
			@entries = new_entries # ... else, display new entries
		end

		flash.now[:notice] = I18n.t("notices.source_updated", count: 2)+" (#{new_entries.size} #{I18n.t("notices.new_entries", count: new_entries.size)})"

		unless failed_sources.empty?
			flash.now[:error] = I18n.t("errors.invalid_feed")+" (#{failed_sources.join(", ")})"
		end

		render template: "entries/index"
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

	# Fetches and saves the new entries
	def fetch
		feed = Feedjira::Feed.fetch_and_parse(@source.url)

		feed.entries.reverse.each do |e|
			if e.published > @source.last_update
				@source.entries.create!(title: e.title, url: e.url, read: false, fav: false, date: e.published, content: Content.create({ html: e.content || e.summary }))
			end
		end

		@source.update(last_update: feed.entries.first.published)
	end

	# Use callbacks to share common setup or constraints between actions.
	def set_source
		@source = Source.find(params[:id])
	end

	def set_sources
		@sources = Source.all
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def source_params
		params.require(:source).permit(:name, :url, :tagslist_attr)
	end
end
