require_relative 'boot'

require 'rails/all'
require "fileutils"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prophet
	# Constants

	## Favicons
	FAVICON_BASE_URL = "/assets/favicons/"
	FAVICONS_DIR_PATH = "public/#{FAVICON_BASE_URL}/"
	FAVICON_TEMP_PATH = "/tmp/prophet-tmp-favicon.ico"

	## Other
	ENTRIES_LIMIT = 25

	# Main app class
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
		config.after_initialize do
			FileUtils::mkdir "public/assets/favicons" unless File.exists?("public/assets/favicons")
		end
  end
end
