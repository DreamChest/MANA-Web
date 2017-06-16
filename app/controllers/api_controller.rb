class ApiController < ApplicationController
  before_action :set_all, only: [:all]

  # GET /api/all.json
  # Responds with a JSON containing all entries, sources and tags newer than given date
  def all
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json
    end
  end

  private

  # Set entries, sources and tags for "all" method
  def set_all
    date = params['date'].present? ? params['date'] : Time.at(0)
    @entries = Entry.where('updated_at > ?', date)
    @sources = Source.where('updated_at > ?', date)
    @tags = Tag.where('updated_at > ?', date)
  end
end
