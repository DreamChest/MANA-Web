class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show update destroy content]
  before_action :set_entries, :filter_entries, :order_entries, only: [:index]

  # GET /entries
  # GET /entries.json
  def index; end

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
        format.html { redirect_to @entry, notice: I18n.t('notices.entry_created') }
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
        format.html { redirect_to @entry, notice: I18n.t('notices.entry_updated') }
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
      format.html { redirect_to entries_url, notice: I18n.t('notices.entry_destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Filter entries (by source or by tags depending on query parameters)
  def filter_entries
    if params['tags'].present?
      @entries = @entries.filter_by_tags(params['tags'].split(','))
      @filter_type = 'tags'
      @filter = params['tags']
    elsif params['source'].present?
      @entries = @entries.filter_by_source(params['source'])
      @filter_type = 'source'
      @filter = params['source']
    end
  end

  # Set entries collection
  def order_entries
    @entries = @entries.arrange(params['date'])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Entry.find(params[:id])
  end

  # Set entries
  def set_entries
    @entries = Entry.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def entry_params
    params.require(:entry).permit(:title, :url, :read, :fav, :content)
  end
end
