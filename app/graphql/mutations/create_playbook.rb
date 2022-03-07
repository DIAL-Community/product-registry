class Mutations::CreatePlaybook < Mutations::BaseMutation
  require 'modules/slugger'

  include Modules::Slugger

  argument :name, String, required: true
  argument :slug, String, required: true
  argument :tags, GraphQL::Types::JSON, required: false, default_value: []
  argument :phases, GraphQL::Types::JSON, required: false, default_value: []
  argument :plays, GraphQL::Types::JSON, required: false, default_value: []
  argument :overview, String, required: true
  argument :audience, String, required: false, default_value: ''
  argument :outcomes, String, required: false, default_value: ''
  argument :locale, String, required: true

  field :playbook, Types::PlaybookType, null: true
  field :errors, [String], null: true

  def resolve(name:, slug:, tags:, phases:, overview:, audience:, outcomes:, plays:, locale:)
    if !is_admin
      return {
        playbook: nil,
        errors: ["Must be admin to create a playbook"]
      }
    end

    playbook = Playbook.find_by(slug: slug)

    if playbook.nil?
      playbook = Playbook.new(name: name)
      playbook.slug = slug_em(name)
    end
    playbook.phases = phases
    playbook.tags = tags
    if playbook.save
      playbook_desc = PlaybookDescription.find_by(playbook: playbook, locale: locale)
      if playbook_desc.nil?
        playbook_desc = PlaybookDescription.new
      end
      playbook_desc.playbook = playbook
      playbook_desc.locale = locale
      playbook_desc.overview = overview
      playbook_desc.audience = audience
      playbook_desc.outcomes = outcomes
      playbook_desc.save

      playbook.plays = []
      plays.each do |play|
        curr_play = Play.find(play["id"])
        
        if !curr_play.nil? 
          playbook_play = PlaybookPlay.new
          playbook_play.playbook = playbook
          playbook_play.play = curr_play
          playbook_play.order = play["order"]
          playbook_play.save
        end
      end
      playbook.save

      # Successful creation, return the created object with no errors
      {
        playbook: playbook,
        errors: []
      }
    else
      # Failed save, return the errors to the client
      {
        playbook: nil,
        errors: user.errors.full_messages
      }
    end
  end
end
