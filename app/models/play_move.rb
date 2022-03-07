class PlayMove < ApplicationRecord
  has_many :move_descriptions, dependent: :destroy

  def play_name
    play = Play.find(play_id)
    play.name
  end

  def play_slug
    play = Play.find(play_id)
    play.slug
  end
end