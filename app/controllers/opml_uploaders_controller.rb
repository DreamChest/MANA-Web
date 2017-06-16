class OpmlUploadersController < ApplicationController
  before_action :set_sources, only: [:create]
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

        @opml_uploader.parse

        format.html { render 'sources/index' }
        format.json do
          flash[:notice] = I18n.t(
            'notices.opml_imported',
            new_count: @opml_uploader.new_count,
            new_string: t('words.new_f', count: @opml_uploader.new_count).downcase,
            source_string: t('words.source', count: @opml_uploader.new_count).downcase,
            ignored_count: @opml_uploader.ignored_count,
            ignored_string: t('words.ignored_f', count: @opml_uploader.ignored_count).downcase
          )
          render :show, status: :created, location: @opml_uploader
        end
      else
        format.html { render :new }
        format.json { render json: @opml_uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Destroy the OPML uploader and file once the parsing is done
  def destroy_opml_uploader
    OpmlUploader.all.each(&:destroy) # Actually, make sure that ALL OPML uploaders are destroyed
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def opml_uploader_params
    params.fetch(:opml_uploader, {}).permit(:file)
  end
end
