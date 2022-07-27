# frozen_string_literal: true

module Mutations
  class DeleteTag < Mutations::BaseMutation
    argument :id, ID, required: true

    field :tag, Types::TagType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          tag: nil,
          errors: ['Must be admin to delete a tag.']
        }
      end

      tag = Tag.find_by(id: id)
      if tag.nil?
        return {
          tag: nil,
          errors: ['Unable to uniquely identify tag to delete.']
        }
      end

      ActiveRecord::Base.transaction do
        delete_query = <<~SQL
          tags = ARRAY_REMOVE(tags, :tag_name)
        SQL
        sanitized_sql = ActiveRecord::Base.sanitize_sql([delete_query, { tag_name: tag.name }])
        Dataset.update_all(sanitized_sql)

        Playbook.update_all(sanitized_sql)
        Play.update_all(sanitized_sql)

        Product.update_all(sanitized_sql)
        Project.update_all(sanitized_sql)
        UseCase.update_all(sanitized_sql)

        if tag.destroy
          # Successful deletion, return the nil tag with no errors
          return {
            tag: tag,
            errors: []
          }
        end
      end
      # Failed delete, return the errors to the client.
      # We will only reach this block if the transaction is failed.
      {
        tag: nil,
        errors: tag.errors.full_messages
      }
    end
  end
end
