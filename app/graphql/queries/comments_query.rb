# frozen_string_literal: true

module Queries
  class CommentsQuery < Queries::BaseQuery
    argument :comment_object_type, String, required: true
    argument :comment_object_id, Int, required: true
    type [Types::CommentType], null: false

    def resolve(comment_object_type:, comment_object_id:)
      comments = Comment.where(comment_object_type: comment_object_type,
                               comment_object_id: comment_object_id,
                               parent_comment_id: nil)
      comments
    end
  end

  class CountCommentsQuery < Queries::BaseQuery
    argument :comment_object_type, String, required: true
    argument :comment_object_id, Int, required: true
    type Integer, null: false

    def resolve(comment_object_type:, comment_object_id:)
      comments_count = Comment.where(comment_object_type: comment_object_type,
                                     comment_object_id: comment_object_id).count
      comments_count
    end
  end
end
