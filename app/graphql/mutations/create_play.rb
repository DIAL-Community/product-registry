# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreatePlay < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :tags, GraphQL::Types::JSON, required: false, default_value: []
    argument :description, String, required: true

    field :play, Types::PlayType, null: false
    field :errors, [String], null: false

    def resolve(name:, slug:, description:, tags:)
      unless is_admin
        return {
          playbook: nil,
          errors: ['Must be admin to create a playbook']
        }
      end

      play = Play.find_by(slug: slug)
      if play.nil?
        play = Play.new(name: name)
        play.slug = slug_em(name)

        first_duplicate = Play.slug_starts_with(play.slug).order(slug: :desc).first
        play.slug = play.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if play.name != name
        play.name = name
        play.slug = slug_em(name)

        first_duplicate = Play.slug_starts_with(play.slug).order(slug: :desc).first
        play.slug = play.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
      end

      play.tags = tags

      if play.save
        play_desc = PlayDescription.find_by(play: play, locale: I18n.locale)
        play_desc = PlayDescription.new if play_desc.nil?
        play_desc.play = play
        play_desc.locale = I18n.locale
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
          errors: play.errors.full_messages
        }
      end
    end

    def generate_offset(first_duplicate)
      size = 1
      unless first_duplicate.nil?
        size = first_duplicate.slug
                              .slice(/_dup\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "_dup#{size}"
    end
  end

  class DuplicatePlay < Mutations::BaseMutation
    include Modules::Slugger

    argument :play_slug, String, required: true

    field :play, Types::PlayType, null: false
    field :errors, [String], null: false

    def resolve(play_slug:)
      unless is_admin
        return {
          playbook: nil,
          errors: ['Must be admin to create a playbook']
        }
      end

      base_play = Play.find_by(slug: play_slug)
      if base_play.nil?
        return {
          play: nil,
          errors: 'Unable to find play to duplicate.'
        }
      end

      # Create a duplicate of the base play object.
      duplicate_play = base_play.dup

      # Update the slug to the new slug value ($slug + '_dupX').
      first_duplicate = Play.slug_starts_with(base_play.slug).order(slug: :desc).first
      duplicate_play.slug = duplicate_play.slug + generate_offset(first_duplicate)

      if duplicate_play.save
        {
          play: duplicate_play,
          errors: []
        }
      else
        {
          play: nil,
          errors: "Unable to create duplicate play record. Message: #{duplicate_play.errors.full_messages}."
        }
      end
    end

    def generate_offset(first_duplicate)
      size = 1
      unless first_duplicate.nil?
        size = first_duplicate.slug
                              .slice(/_dup\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "_dup#{size}"
    end
  end

  class UpdatePlay < Mutations::BaseMutation
    argument :playbook_slug, String, required: true
    argument :play_slug, String, required: true
    argument :operation, String, required: true
    argument :distance, Integer, required: false

    field :play, Types::PlayType, null: false
    field :errors, [String], null: false

    def resolve(playbook_slug:, play_slug:, operation:, distance:)
      unless is_admin
        return {
          playbook: nil,
          errors: ['Must be admin to create a playbook']
        }
      end

      playbook = Playbook.find_by(slug: playbook_slug)

      if playbook.nil?
        return {
          play: nil,
          errors: 'Unable to find playbook record.'
        }
      end

      play = Play.find_by(slug: play_slug)

      if play.nil?
        return {
          play: nil,
          errors: 'Unable to find play record.'
        }
      end

      successful_operation = false
      case operation
      when 'UNASSIGN'
        # We're deleting the play because the order -1
        deleted = playbook.plays.delete(play)
        successful_operation = true unless deleted.nil?
      when 'ASSIGN'
        # We're adding a play, the order is length of the current plays (appending as the last play).
        max_order = PlaybookPlay.where(playbook: playbook).maximum('order')
        max_order = max_order.nil? ? 0 : (max_order + 1)

        assigned_play = PlaybookPlay.new
        assigned_play.play = play
        assigned_play.playbook = playbook
        assigned_play.order = max_order
        successful_operation = true if assigned_play.save
      else
        # Reordering actually trigger swap order with adjacent play.
        playbook_play = PlaybookPlay.find_by(playbook: playbook, play: play)
        playbook_play_index = playbook.playbook_plays.index(playbook_play)
        # Find adjacent play
        swapped_playbook_play = playbook.playbook_plays[playbook_play_index + distance]
        # Swap the order
        temp_order = playbook_play.order
        playbook_play.order = swapped_playbook_play.order
        swapped_playbook_play.order = temp_order
        # Save both playbook_play
        successful_operation = true if playbook_play.save && swapped_playbook_play.save
      end

      if successful_operation
        {
          play: play,
          errors: []
        }
      else
        {
          play: nil,
          errors: "Unable to add play record. Message: #{playbook.errors.full_messages}."
        }
      end
    end
  end
end
