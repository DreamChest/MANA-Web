class OpmlUploader < ApplicationRecord
  require 'nokogiri' # For OPML file parsing

  has_attached_file :file

  # Imported and ignored sources count
  attr_accessor :new_count, :ignored_count

  validates_attachment :file, presence: true, content_type: { content_type: [
    'application/xml',
    'text/xml',
    'text/x-opml',
    'text/x-opml+xml'
  ] }

  # Parse OPML file and create tags and sources to import
  def parse
    new_s = [] # New (imported) sources
    ignored_s = [] # Ignored (not/already imported) sources

    doc = Nokogiri::XML(File.open(file.path))

    doc.xpath("//outline[@type='tag']").each do |xtag|
      tname = xtag.xpath('@text').text

      # Take tag from DB (if possible) or create it
      tag =
        Tag.where('name = ?', tname).take ||
        Tag.create(name: tname, color: '#ffffff')

      xtag.xpath("outline[@type='rss']").each do |xsource|
        xml_url = xsource.xpath('@xmlUrl').text

        # Pull source from DB (if it exists) or create it
        source = Source.where('url = ?', xml_url).take
        if source.nil?
          source = Source.create(
            name: xsource.xpath('@text').text,
            url: xml_url,
            html_url: xsource.xpath('@htmlUrl').text,
            last_update: Time.at(0)
          )
          new_s.push(source)
        elsif !new_s.include?(source) && !ignored_s.include?(source)
          ignored_s.push(source)
        end

        # Tag source with tag (unless it is already tagged)
        source.tags << tag unless source.tags.exists?(tag.id)
      end
    end

    self.new_count = new_s.size
    self.ignored_count = ignored_s.size
  end
end
