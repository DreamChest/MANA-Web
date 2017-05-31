class OpmlUploadersController < ApplicationController
	before_action :set_opml_uploader, only: [:show, :edit, :update, :destroy]

	# GET /opml_uploaders
	# GET /opml_uploaders.json
	def index
		@opml_uploaders = OpmlUploader.all
	end

	# GET /opml_uploaders/1
	# GET /opml_uploaders/1.json
	def show
	end

	# GET /opml_uploaders/new
	def new
		@opml_uploader = OpmlUploader.new
	end

	# GET /opml_uploaders/1/edit
	def edit
	end

	# POST /opml_uploaders
	# POST /opml_uploaders.json
	def create
		@opml_uploader = OpmlUploader.new(opml_uploader_params)

		respond_to do |format|
			if @opml_uploader.save

				require "nokogiri"

				doc = Nokogiri::XML(File.open(@opml_uploader.file.path))

				doc.xpath("//outline[@type='tag']").each do |xtag| # For each tag in OPML file
					tagName = xtag.xpath("@text").text # Tag name from OPML
					tag = Tag.where("name = ?", tagName).take # Pull tag from DB (if it exists)
					tag = tag ? tag : Tag.create(name: tagName, color: "#ffffff") # Keep tag if it exists in DB, else create it
					puts "Tag #{tagName} has:"
					xtag.xpath("outline[@type='rss']").each do |xsource| # For each source of the tag in OPML file
						sourceName = xsource.xpath("@text").text # Source name from OPML
						sourceXmlUrl = xsource.xpath("@xmlUrl").text # Source XML URL from OPML
						sourceHtmlUrl = xsource.xpath("@htmlUrl").text # Source HTML URL from OPML
						source = Source.where("url = ?", sourceXmlUrl).take # Pull source from DB (if it exists)
						source = source ? source : Source.create(name: sourceName, url: sourceXmlUrl, html_url: sourceHtmlUrl, last_update: Time.at(0)) # Keep source if it exists in DB, else create it
						source.tags<<(tag) unless source.tags.exists?(tag.id) # Tag source with tag (unless it is already tagged)
						puts "\tSource: #{sourceName}, #{sourceXmlUrl}, #{sourceHtmlUrl}"
					end
				end

				format.html {
					@sources = Source.all
					render "sources/index"
				}
				format.json {
					flash[:notice] = I18n.t("notices.opml_imported")
					render :show, status: :created, location: @opml_uploader
				}
			else
				format.html { render :new }
				format.json { render json: @opml_uploader.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /opml_uploaders/1
	# PATCH/PUT /opml_uploaders/1.json
	def update
		respond_to do |format|
			if @opml_uploader.update(opml_uploader_params)
				format.html { redirect_to @opml_uploader, notice: 'Opml uploader was successfully updated.' }
				format.json { render :show, status: :ok, location: @opml_uploader }
			else
				format.html { render :edit }
				format.json { render json: @opml_uploader.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /opml_uploaders/1
	# DELETE /opml_uploaders/1.json
	def destroy
		@opml_uploader.destroy
		respond_to do |format|
			format.html { redirect_to opml_uploaders_url, notice: 'Opml uploader was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_opml_uploader
		@opml_uploader = OpmlUploader.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def opml_uploader_params
		params.fetch(:opml_uploader, {}).permit(:file)
	end
end
