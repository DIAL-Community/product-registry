# frozen_string_literal: true

module Mutations
  class DeleteComment < Mutations::BaseMutation
    argument :comment_id, String, required: true

    field :comment, Types::CommentType, null: true
    field :errors, [String], null: true

    def resolve(comment_id:)
      comment = Comment.find_by(comment_id: comment_id)

      unless an_admin || a_comment_author(comment.author['id'])
        return {
          comment: nil,
          errors: ['Must be admin or comment author to delete a comment.']
        }
      end

      comment_children = Comment.where(parent_comment_id: comment_id)
      comment_children&.destroy_all

      if comment.destroy
        # Successful deletetion, return the nil comment with no errors
        {
          comment: nil,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          comment: comment,
          errors: comment.errors.full_messages
        }
      end
    end

    def a_comment_author(author_id)
      if !context[:current_user].nil? && context[:current_user].id.equal?(author_id)
        true
      else
        false
      end
    end
  end
end
