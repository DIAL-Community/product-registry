class Mutations::CreatePlay < Mutations::BaseMutation
  require 'modules/slugger'

  include Modules::Slugger

  argument :name, String, required: true
  argument :tags, GraphQL::Types::JSON, required: false, default_value: []
  argument :description, String, required: true
  argument :locale, String, required: true

  field :play, Types::PlayType, null: false
  field :errors, [String], null: false

  def resolve(name:, description:, tags:, locale:)
    slug = slug_em(name)
    play = Play.find_by(slug: slug)
    if play.nil?
      play = Play.new(name: name)
      play.slug = slug_em(name)
    end

    play.tags = tags
    if play.save
      play_desc = PlayDescription.find_by(play: play, locale: locale)
      if play_desc.nil?
        play_desc = PlayDescription.new
      end
      play_desc.play = play
      play_desc.locale = locale
      play_desc.description = description
      play_desc.save

      # Successful creation, return the created object with no errors
      {
        play: play,
        errors: []
      }
    else
      # Failed save, return the errors to the client
      {
        play: nil,
        errors: user.errors.full_messages
      }
    end
  end
end
