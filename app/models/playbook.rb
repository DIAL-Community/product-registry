class Playbook < ApplicationRecord
  include Auditable
  attr_accessor :playbook_overview, :playbook_audience, :playbook_outcomes, :playbook_cover

  has_many :playbook_descriptions, dependent: :destroy
  has_and_belongs_to_many :sectors, join_table: :playbooks_sectors
  has_and_belongs_to_many :plays, -> { order('playbook_plays.order') }, dependent: :destroy, join_table: :playbook_plays
  has_many :playbook_plays

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end

  def playbook_play_with_slug_list
    returned_list = []
    playbook_plays.each do |playbook_play|
      playbook_play_hash = playbook_play.attributes
      playbook_play_hash['playbook_slug'] = slug
      playbook_play_hash['play_slug'] = playbook_play.play.slug
      playbook_play_hash['play_name'] = playbook_play.play.name
      returned_list << playbook_play_hash
    end
    returned_list
  end

  def playbook_description_localized
    description = playbook_descriptions.order('LENGTH(overview) DESC')
                                       .find_by(locale: I18n.locale)
    if description.nil?
      description = playbook_descriptions.order('LENGTH(overview) DESC')
                                         .find_by(locale: 'en')
    end
    description
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'playbooks', "#{slug}.png"))
      "/assets/playbooks/#{slug}.png"
    else
      "/assets/playbooks/playbook_placeholder.png"
    end
  end
end
