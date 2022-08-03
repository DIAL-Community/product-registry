# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateTag < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: false

    field :tag, Types::TagType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:)
      unless an_admin || a_content_editor
        return {
          tag: nil,
          errors: ['Must be admin or content editor to create a tag']
        }
      end

      # Prevent duplicating tag by the name of the tag.
      tag = Tag.find_by(slug: slug)
      if tag.nil?
        tag = Tag.find_by(name: name)
      end

      if tag.nil?
        tag = Tag.new(name: name, slug: slug_em(name))
      end

      # Not a new record and current name is different with the existing name.
      updating_name = !tag.new_record? && tag.name != name

      ActiveRecord::Base.transaction do
        if updating_name
          update_query = <<~SQL
            tags = ARRAY_APPEND(ARRAY_REMOVE(tags, :existing_tag_name), :tag_name)
            WHERE :existing_tag_name = ANY(tags)
          SQL
          sanitized_update = ActiveRecord::Base.sanitize_sql([
            update_query,
            { tag_name: name, existing_tag_name: tag.name }
          ])

          Dataset.update_all(sanitized_update)

          Playbook.update_all(sanitized_update)
          Play.update_all(sanitized_update)

          Product.update_all(sanitized_update)
          Project.update_all(sanitized_update)
          UseCase.update_all(sanitized_update)
        end

        tag.name = name
        if tag.save
          tag_description = TagDescription.find_by(tag_id: tag.id, locale: I18n.locale)
          tag_description = TagDescription.new if tag_description.nil?

          tag_description.description = description
          tag_description.tag_id = tag.id
          tag_description.locale = I18n.locale
          tag_description.save

          # Successful creation, return the created object with no errors
          return {
            tag: tag,
            errors: []
          }
        end
      end
      # Failed save, return the errors to the client.
      # We will only reach this block if the transaction is failed.
      {
        tag: nil,
        errors: tag.errors.full_messages
      }
    end
  end
end
