class Tag < ApplicationRecord
  # string name
  # string color

  has_and_belongs_to_many :sources

  validates :name, :color, presence: true

  # Returns all tags list as a string
  def self.list
    all.map(&:name).join(',')
  end

  # Returns tag sources list as a string
  def sourceslist
    sources.map(&:name).join(',')
  end

  # Returns wether or not a tag has sources
  def sources?
    !sources.empty?
  end

  # Define html attributes to use on index page if the tag has no sources
  # TODO: should be helper ?
  def no_sources_html_attr
    sources? ? {} : { class: 'warning', data: { toggle: 'tooltip' }, title: I18n.t('tooltips.unused_tag') }
  end
end
