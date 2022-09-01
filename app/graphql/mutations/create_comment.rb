# frozen_string_literal: true

require 'modules/slugger'
require 'modules/notifier'

module Mutations
  class CreateComment < Mutations::BaseMutation
    include Modules::Slugger
    include Modules::Notifier

    argument :comment_id, String, required: false
    argument :comment_object_type, String, required: true
    argument :comment_object_id, Integer, required: true
    argument :text, String, required: true
    argument :user_id, Integer, required: true
    argument :parent_comment_id, String, required: false

    field :comment, Types::CommentType, null: true
    field :errors, [String], null: true

    def resolve(comment_id:, comment_object_type:, comment_object_id:, text:, user_id:, parent_comment_id: nil)
      current_user = User.find_by(id: user_id)
      comment = Comment.find_by(comment_id: comment_id)

      if comment.nil?
        comment = Comment.new(comment_object_type: comment_object_type,
                              comment_object_id: comment_object_id,
                              comment_id: comment_id)
        comment.parent_comment_id = parent_comment_id unless parent_comment_id.nil?

        comment.author = { "id": current_user.id,
                           "username": current_user.username }
      end

      comment.text = text

      if comment.save
        # Notify original commenter if someone has replied to their comment
        notify_commenter(comment) unless parent_comment_id.nil?

        # Successful creation, return the created object with no errors
        {
          comment: comment,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          comment: nil,
          errors: comment.errors.full_messages
        }
      end
    end
  end
end
