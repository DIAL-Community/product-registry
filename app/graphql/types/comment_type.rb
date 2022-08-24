# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :comment_object_type, String, null: false
    field :comment_object_id, Integer, null: false
    field :author, GraphQL::Types::JSON, null: true
    field :text, String, null: true
    field :parent_comment_id, String, null: true
    field :comment_id, String, null: false
  end
end
