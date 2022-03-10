class PlayMove < ApplicationRecord
  has_many :move_descriptions, dependent: :destroy

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
