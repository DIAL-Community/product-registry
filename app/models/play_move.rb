# frozen_string_literal: true

class PlayMove < ApplicationRecord
  belongs_to :play
  has_many :move_descriptions, dependent: :destroy

  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def move_description_localized
    description = move_descriptions.order('LENGTH(description) DESC')
                                   .find_by(locale: I18n.locale)
    if description.nil?
      description = move_descriptions.order('LENGTH(description) DESC')
                                     .find_by(locale: 'en')
    end
    description
  end

  def play_name
    play = Play.find(play_id)
    play.name
  end

  def play_slug
    play = Play.find(play_id)
    play.slug
  end
end
