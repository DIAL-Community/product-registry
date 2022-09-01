# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :comment_object_type, String, null: false
    field :comment_object_id, Integer, null: false
    field :author, GraphQL::Types::JSON, null: true
    field :text, String, null: true
    field :comment_id, String, null: false

    field :parent_comment_id, String, null: true
    field :replies, [Types::CommentType], null: true

    # Added fields to match frontent library
    field :com_id, String, null: false
    field :user_id, String, null: false
    field :full_name, String, null: false
    field :avatar_url, String, null: false
  end
end
