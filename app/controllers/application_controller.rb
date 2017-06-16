class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  # Check for AJAX request, if so, render without layout
  layout(proc { request.xhr? ? 'mini' : nil })

  # GET /sidebars
  # Renders a view with sidebars only
  def sidebars
    respond_to do |format|
      format.html { render 'application/sidebars', layout: false }
    end
  end

  # Set sources
  def set_sources
    @sources = Source.all
  end

  # Set tags
  def set_tags
    @tags = Tag.all
  end

  private

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  # Sets locale for requested page
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
