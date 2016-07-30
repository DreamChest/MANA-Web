class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :update, :destroy]

  # GET /entries
  # GET /entries.json
  def index
	  if not params["tags"].nil?
		  @entries = Entry.all.order("date ASC").select do |e|
			  e.source.tagslist.include? params["tags"]
		  end
		  @filter = params["tags"]
	  elsif not params["source"].nil?
			  @entries = Entry.all.order("date ASC").select do |e|
				  e.source.name == params["source"]
			  end
			  @filter = params["source"]
	  else
		  @entries = Entry.all.order("date ASC")
	  end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
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
