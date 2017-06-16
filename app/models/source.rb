class Source < ApplicationRecord
  require 'feedjira' # RSS feed fetching and parsing
  require 'open-uri' # To get favicon file
  require 'open_uri_redirections' # Allow open-uri for unsecured redirections
  require 'rmagick' # For convertir favicon ico files into png files

  has_many :entries, dependent: :destroy
  has_and_belongs_to_many :tags
  attr_accessor :tagslist_attr, :feed

  validates :name, :url, presence: true
  validates :url, url: true

  # Returns source tags list as a string
  def tagslist
    tags.map(&:name).join(',')
  end

  # Tries to fetch the source feed
  def fetch
    self.feed = Feedjira::Feed.fetch_and_parse(url)
    true # In case of success, it will be parsed later
  rescue => ex # Else, log the exception message and add error for controller
    logger.info ex.message
    errors.add(:url, I18n.t('forms.validations.errors.invalid_feed'))
    false
  end

  # Parse feed
  def parse
    feed.entries.reverse.each do |e|
      next unless e.published > (last_update || Time.at(0))
      entries.create!(
        title: e.title,
        url: e.url,
        read: false,
        fav: false,
        date: e.published,
        content: Content.create(html: e.content || e.summary)
      )
    end

    update(html_url: feed.url, last_update: feed.entries.first.published)
  end

  # Reset entries (clears and parse from scratch)
  def reset_entries
    entries.clear
    update(last_update: Time.at(0))
    parse
  end

  # Tags the source with provided tags (param: array of tag names)
  def tag(taglist)
    tags.clear
    taglist.each do |t|
      tag =
        Tag.where('name = ?', t).take ||
        Tag.create(name: t, color: '#ffffff')
      tags << tag
    end
  end

  # Returns the file name for the favicon
  def favicon_name
    "#{id}.png"
  end

  # Returns the file path for the favicon
  def favicon_path
    "#{Prophet::FAVICONS_DIR_PATH}/#{favicon_name}"
  end

  # Gets the favicon for the source
  def fetch_favicon
    uri = "#{html_url}/favicon.ico"

    open(Prophet::FAVICON_TEMP_PATH, 'wb') do |file|
      file << open(uri, allow_redirections: :all).read
    end

    ico = Magick::Image.read(Prophet::FAVICON_TEMP_PATH).first
    ico.write(favicon_path)

    update(favicon: "#{Prophet::FAVICON_BASE_URL}#{favicon_name}")
    true
  rescue => ex
    logger.info ex.message
    false
  end
end
