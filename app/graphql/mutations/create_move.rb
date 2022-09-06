# frozen_string_literal: true

module Mutations
  class CreateMove < Mutations::BaseMutation
    require 'modules/slugger'

    include Modules::Slugger

    argument :play_slug, String, required: true
    argument :move_slug, String, required: false
    argument :name, String, required: true
    argument :description, String, required: true
    argument :resources, GraphQL::Types::JSON, required: false, default_value: []

    field :move, Types::MoveType, null: true
    field :errors, [String], null: false

    def resolve(play_slug:, move_slug:, name:, description:, resources:)
      unless an_admin
        return {
          move: nil,
          errors: ['Not allowed to create a move.']
        }
      end

      play = Play.find_by(slug: play_slug)
      if play.nil?
        return {
          move: nil,
          errors: ['Unable to find play.']
        }
      end

      play_move = PlayMove.find_by(play: play, slug: move_slug)
      if play_move.nil?
        play_move = PlayMove.new(name: name)
        play_move.slug = slug_em(name)
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if play_move.name != name
        play_move.name = name
        play_move.slug = slug_em(name)
      end

      if PlayMove.where(slug: play_move.slug).count.positive?
        # Check if we need to add _dup to the slug.
        first_duplicate = PlayMove.slug_simple_starts_with(play_move.slug).order(slug: :desc).first
        play_move.slug = play_move.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
      end

      play_move.play = play
      play_move.order = play.play_moves.count
      play_move.resources = resources.reject { |resource| resource['name'].blank? || resource['url'].blank? }
      if play_move.save
        move_desc = MoveDescription.find_by(play_move_id: play_move, locale: I18n.locale)
        if move_desc.nil?
          move_desc = MoveDescription.new
          move_desc.play_move = play_move
          move_desc.locale = I18n.locale
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
          errors: play_move.errors.full_messages
        }
      end
    end
  end

  class CreateResource < Mutations::BaseMutation
    require 'modules/slugger'

    include Modules::Slugger

    argument :play_slug, String, required: true
    argument :move_slug, String, required: false
    argument :url, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true
    argument :index, Integer, required: true

    field :move, Types::MoveType, null: true
    field :errors, [String], null: false

    def resolve(play_slug:, move_slug:, url:, name:, description:, index:)
      return { move: nil, errors: ['Not allowed to update move.'] } unless an_admin

      play = Play.find_by(slug: play_slug)
      return { move: nil, errors: ['Unable to find play.'] } if play.nil?

      play_move = PlayMove.find_by(play: play, slug: move_slug)
      return { move: nil, errors: ['Unable to find move.'] } if play_move.nil?

      if index >= play_move.resources.count
        # The index is higher or equal than the current count of the resource.
        # Append the new resource to the move.
        play_move.resources << {
          i: play_move.resources.count,
          name: name,
          description: description,
          url: url
        }
      else
        # The index is less length of the resources
        play_move.resources.each_with_index do |resource, i|
          next if index != i

          resource['url'] = url
          resource['name'] = name
          resource['description'] = description
        end
      end

      if play_move.save
        # Successful creation, return the created object with no errors
        { move: play_move, errors: [] }
      else
        # Failed save, return the errors to the client
        { move: nil, errors: ['Unable to save updated move data.'] }
      end
    end
  end

  class UpdateMoveOrder < Mutations::BaseMutation
    argument :play_slug, String, required: true
    argument :move_slug, String, required: true
    argument :operation, String, required: true
    argument :distance, Integer, required: false

    field :move, Types::MoveType, null: true
    field :errors, [String], null: false

    def resolve(play_slug:, move_slug:, operation:, distance:)
      unless an_admin
        return {
          move: nil,
          errors: ['Not allowed to update a play.']
        }
      end

      play = Play.find_by(slug: play_slug)
      if play.nil?
        return {
          move: nil,
          errors: 'Unable to find play record.'
        }
      end

      move = PlayMove.find_by(slug: move_slug, play: play)
      if move.nil?
        return {
          move: nil,
          errors: 'Unable to find move record.'
        }
      end

      successful_operation = false
      case operation
      when 'UNASSIGN'
        # We're deleting the play because the order -1
        deleted = play.play_moves.delete(move)
        successful_operation = true unless deleted.nil?
      else
        # Reordering actually trigger swap order with adjacent play.
        play_move = PlayMove.find_by(play: play, slug: move_slug)
        play_move_index = play.play_moves.index(play_move)
        # Find adjacent play
        swapped_play_move = play.play_moves[play_move_index + distance]
        # Swap the order
        temp_order = play_move.order
        play_move.order = swapped_play_move.order
        swapped_play_move.order = temp_order
        # Save both playbook_play
        successful_operation = true if play_move.save && swapped_play_move.save
      end

      if successful_operation
        {
          move: move,
          errors: []
        }
      else
        {
          move: nil,
          errors: "Unable to add play record. Message: #{play_move.errors.full_messages}."
        }
      end
    end
  end
end
