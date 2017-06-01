class OpmlUploadersController < ApplicationController
	before_action :set_opml_uploader, only: [:show, :edit, :update, :destroy]
	after_action :destroy_opml_uploader, only: [:create]

	# GET /opml_uploaders/new
	def new
		@opml_uploader = OpmlUploader.new
	end

	# POST /opml_uploaders
	# POST /opml_uploaders.json
	def create
		@opml_uploader = OpmlUploader.new(opml_uploader_params)

		respond_to do |format|
			if @opml_uploader.save

				require "nokogiri"

				doc = Nokogiri::XML(File.open(@opml_uploader.file.path))

				new_sources = 0 # Count for new sources
				ignored_sources = 0 # Count for ignore sources (already existent)

				doc.xpath("//outline[@type='tag']").each do |xtag| # For each tag in OPML file
					tagName = xtag.xpath("@text").text # Tag name from OPML

					tag = Tag.where("name = ?", tagName).take # Pull tag from DB (if it exists)
					tag = tag ? tag : Tag.create(name: tagName, color: "#ffffff") # Keep tag if it exists in DB, else create it

					xtag.xpath("outline[@type='rss']").each do |xsource| # For each source of the tag in OPML file
						sourceName = xsource.xpath("@text").text # Source name from OPML
						sourceXmlUrl = xsource.xpath("@xmlUrl").text # Source XML URL from OPML
						sourceHtmlUrl = xsource.xpath("@htmlUrl").text # Source HTML URL from OPML

						source = Source.where("url = ?", sourceXmlUrl).take # Pull source from DB (if it exists)
						if source.nil? # If source does not exist...
							source = Source.create(name: sourceName, url: sourceXmlUrl, html_url: sourceHtmlUrl, last_update: Time.at(0)) # ... we create it.
							new_sources += 1
						else
							ignored_sources += 1
						end

						source.tags<<(tag) unless source.tags.exists?(tag.id) # Tag source with tag (unless it is already tagged)
					end
				end

				format.html {
					@sources = Source.all
					render "sources/index"
				}
				format.json {
					flash[:notice] = I18n.t("notices.opml_imported",
											new_count: new_sources,
											new_string: t("words.new_f", count: new_sources).downcase,
											source_string: t("words.source", count: new_sources).downcase,
											ignored_count: ignored_sources,
											ignored_string: t("words.ignored_f", count: ignored_sources).downcase)

					render :show, status: :created, location: @opml_uploader
				}
			else
				format.html { render :new }
				format.json { render json: @opml_uploader.errors, status: :unprocessable_entity }
			end
		end
	end

	private
	# Destroy the OPML uploader (and the uploaded file) after it's creation
	# (Used because we don't want to store the file nor keep the uploader, since we only want to parse the OPML file)
	def destroy_opml_uploader
		OpmlUploader.all.each do |o| o.destroy end # Actually, make sure that ALL OPML uploaders are destroyed
	end

	# Use callbacks to share common setup or constraints between actions.
	def set_opml_uploader
		@opml_uploader = OpmlUploader.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def opml_uploader_params
		params.fetch(:opml_uploader, {}).permit(:file)
	end
end
