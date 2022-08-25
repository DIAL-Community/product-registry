# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreatePlaybook < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :cover, ApolloUploadServer::Upload, required: false
    argument :author, String, required: false
    argument :tags, GraphQL::Types::JSON, required: false, default_value: []
    argument :plays, GraphQL::Types::JSON, required: false, default_value: []
    argument :overview, String, required: true
    argument :audience, String, required: false, default_value: ''
    argument :outcomes, String, required: false, default_value: ''
    argument :draft, Boolean, required: true, default_value: true

    field :playbook, Types::PlaybookType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, author:, tags:, overview:, audience:, outcomes:, plays:, cover: nil, draft:)
      unless an_admin || a_content_editor
        return {
          playbook: nil,
          errors: ['Must be admin or content editor to create a playbook']
        }
      end

      playbook = Playbook.find_by(slug: slug)

      if playbook.nil?
        playbook = Playbook.new(name: name)
        playbook.slug = slug_em(name)

        if Playbook.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Playbook.slug_starts_with(slug_em(name)).order(slug: :desc).first
          playbook.slug = playbook.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if playbook.name != name
        playbook.name = name
        playbook.slug = slug_em(name)

        if Playbook.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Playbook.slug_starts_with(playbook.slug).order(slug: :desc).first
          playbook.slug = playbook.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      playbook.tags = tags
      playbook.author = author
      playbook.draft = draft

      if playbook.save
        unless cover.nil?
          uploader = LogoUploader.new(playbook, cover.original_filename, context[:current_user])
          begin
            uploader.store!(cover)
          rescue StandardError => e
            puts "Unable to save cover for: #{playbook.name}. Standard error: #{e}."
          end
          playbook.auditable_image_changed(cover.original_filename)
        end

        playbook_desc = PlaybookDescription.find_by(playbook: playbook, locale: I18n.locale)
        playbook_desc = PlaybookDescription.new if playbook_desc.nil?
        playbook_desc.playbook = playbook
        playbook_desc.locale = I18n.locale
        playbook_desc.overview = overview
        playbook_desc.audience = audience
        playbook_desc.outcomes = outcomes
        playbook_desc.save

        index = 0
        playbook.plays = []
        plays.each do |play|
          curr_play = Play.find(play['id'])
          next if curr_play.nil?

          playbook_play = PlaybookPlay.new
          playbook_play.playbook = playbook
          playbook_play.play = curr_play
          playbook_play.order = index
          playbook_play.save

          index += 1
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
          errors: playbook.errors.full_messages
        }
      end
    end
  end
end
