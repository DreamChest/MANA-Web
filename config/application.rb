require_relative 'boot'

require 'rails/all'
require 'fileutils'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prophet
  # Main app class
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.after_initialize do
      FileUtils.mkdir_p Prophet::FAVICON_DIR_PATH unless File.exist?(Prophet::FAVICON_DIR_PATH)
    end
  end

  # Constants

  ## Favicons
  FAVICON_BASE_URL = '/assets/favicons'.freeze
  FAVICON_DIR_PATH = Rails.root.join("public#{FAVICON_BASE_URL}").freeze
  FAVICON_TEMP_PATH = 'tmp/favicon.ico'.freeze
  FAVICON_PLACEHOLDER = 'placeholder.png'.freeze

  ## Other
  ENTRIES_LIMIT = 25
end
