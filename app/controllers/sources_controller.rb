class SourcesController < ApplicationController
  require 'fileutils' # To delete favicon file on source deletion

  before_action :set_source, only: %i[show edit update destroy entries update_entries]
  before_action :set_sources, only: %i[index create update destroy update_entries update_all]
  before_action :set_tags, only: [:index]

  # GET /sources
  # GET /sources.json
  def index
    respond_to do |format|
      format.html
      format.json
      format.opml
    end
  end

  # GET /sources/1
  # GET /sources/1.json
  def show
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json
    end
  end

  # GET /sources/new
  def new
    @source = Source.new
    @entries = @source.entries.build
    @tags = @source.tags.build
  end

  # GET /sources/1/edit
  def edit; end

  # POST /sources
  # POST /sources.json
  def create
    @source = Source.new(source_params)

    respond_to do |format|
      if @source.valid? && @source.fetch # If source can be saved (all validations passed)
        @source.save # Source is saved
        @source.parse # Feed is parsed and entries created
        @source.tag(params[:source]['tagslist_attr'].split(',')) # Source is tagged
        @source.fetch_favicon # Fetch the source favicon

        format.html { render :index }
        format.json do
          flash[:notice] = I18n.t('notices.source_created')
          flash[:error] = I18n.t('errors.favicon_error') unless @source.favicon?
          render :show, status: :created, location: @source
        end
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

    respond_to do |format|
      if @source.valid? && @source.fetch # If source can be saved (all validations passed)
        if @source.url_changed?
          @source.reset_entries # Clear and parse entries from scratch
          @source.fetch_favicon # Fetch the source favicon
        elsif !@source.favicon?
          @source.fetch_favicon
        end
        @source.save # Source is saved
        @source.tag(params[:source]['tagslist_attr'].split(',')) # Source is tagged

        format.html { render :index }
        format.json do
          flash[:notice] = I18n.t('notices.source_saved', count: 1)
          flash[:error] = I18n.t('errors.favicon_error') unless @source.favicon?
          render :show, status: :ok, location: @source
        end
      else
        format.html { render :edit }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    FileUtils.rm(@source.favicon_path) if File.exist?(@source.favicon_path)
    @source.destroy

    respond_to do |format|
      format.html do
        flash.now[:notice] = I18n.t('notices.source_destroyed', name: @source.name)
        render :index
      end
      format.json { head :no_content }
    end
  end

  # GET /sources/1/entries
  # Shows entries for the source (JSON only, HTML redirects to entries filtered by the source)
  def entries
    respond_to do |format|
      format.html { redirect_to controller: 'entries', action: 'index', source: @source.name }
      format.json { render json: @source.entries }
    end
  end

  # GET /sources/1/update
  # Updates entries for given source
  def update_entries
    @source.fetch
    @source.parse
    unless @source.favicon?
      flash.now[:error] = I18n.t('errors.favicon_error') unless @source.fetch_favicon
    end

    flash.now[:notice] = I18n.t('notices.source_updated', count: 1, name: @source.name)
    render :index
  rescue
    flash.now[:error] = I18n.t('errors.invalid_feed', count: 1, name: @source.name)
    render :index
  end

  # GET /sources/update
  # Updates all sources (fetches entries for each source)
  def update_all
    # Date of the most recent entry (epoch if no entries)
    mrr = Entry.arrange.first
    mrd = mrr.nil? ? Time.at(0) : mrr.date

    failed_sources = [] # Hash of failed sources

    # Sources update
    @sources.each do |s|
      begin
        s.fetch
        s.parse
        s.fetch_favicon if s.favicon.nil?
      rescue
        failed_sources.push(s.name)
      end
    end

    new_entries = Entry.order('date DESC').where('date > ?', mrd)
    details = "#{new_entries.size} #{I18n.t('notices.new_entries', count: new_entries.size)}"

    # Display new entries if any, else display old ones
    @entries = new_entries.empty? ? Entry.arrange : new_entries
    @filter = details unless new_entries.empty?

    # Notice for successfully updated sources
    flash.now[:notice] = I18n.t('notices.source_updated', count: 2, details: details)

    # Notice for failed sources (if any)
    unless failed_sources.empty?
      flash.now[:error] = I18n.t(
        'errors.invalid_feed',
        count: failed_sources.size,
        name: failed_sources.join(', ')
      )
    end

    render 'entries/index'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_source
    @source = Source.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def source_params
    params.require(:source).permit(:name, :url, :tagslist_attr)
  end
end
