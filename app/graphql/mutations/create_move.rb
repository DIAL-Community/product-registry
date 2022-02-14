class Mutations::CreateMove < Mutations::BaseMutation
  require 'modules/slugger'

  include Modules::Slugger

  argument :play, String, required: true
  argument :name, String, required: true
  argument :description, String, required: true
  argument :resources, GraphQL::Types::JSON, required: false, default_value: []
  argument :locale, String, required: true
  argument :order, Integer, required: true

  field :move, Types::MoveType, null: false
  field :errors, [String], null: false

  def resolve(play:, name:, description:, resources:, order:, locale:)
    play = Play.find_by(slug: play)
    if play.nil?
      return {
        play: nil,
        errors: user.errors.full_messages
      }
    end

    move_slug = slug_em(name)
    play_move = PlayMove.find_by(play_id: play, slug: move_slug)
    if play_move.nil?
      play_move = PlayMove.new
      play_move.name = name
      play_move.slug = move_slug
    end
    play_move.play_id = play.id
    play_move.order = order
    play_move.resources = resources
    if play_move.save
      move_desc = MoveDescription.find_by(play_move_id: play_move, locale: locale)
      if move_desc.nil?
        move_desc = MoveDescription.new
        move_desc.play_move_id = play_move.id
        move_desc.locale = locale
      end
      move_desc.description = description
      move_desc.save

      # Successful creation, return the created object with no errors
      {
        move: play_move,
        errors: []
      }
    else
      # Failed save, return the errors to the client
      {
        move: nil,
        errors: user.errors.full_messages
      }
    end
  end
end
