class Entry < ApplicationRecord
  # string title
  # string url
  # boolean read
  # boolean fav
  # datetime date

  belongs_to :source
  has_one :content, dependent: :destroy

  validates :title, :url, :date, :content, presence: true

  # Returns entries filtered by tags (param: tag array)
  def self.filter_by_tags(taglist)
    joins('
      inner join sources_tags on entries.source_id = sources_tags.source_id
      inner join tags on sources_tags.tag_id = tags.id
    ').where('tags.name in (?)', taglist)
  end

  # Returns entries filtered by source (param: source name)
  def self.filter_by_source(source)
    joins(:source).where('sources.name=?', source)
  end

  # Sorts entries (older than given date) by date and limits the result
  def self.arrange(date = nil)
    e = order('date DESC')
    e = e.where('date < ?', date) unless date.nil?
    e.limit(Prophet::ENTRIES_LIMIT)
  end
end
