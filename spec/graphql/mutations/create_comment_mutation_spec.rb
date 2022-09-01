# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateComment, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateComment (
        $commentId: String!
        $commentObjectType: String!
        $commentObjectId: Int!
        $text: String!
        $userId: Int!
        $parentCommentId: String
      ) {
        createComment (
          commentId: $commentId
          commentObjectType: $commentObjectType
          commentObjectId: $commentObjectId
          text: $text
          userId: $userId
          parentCommentId: $parentCommentId
        ) {
          comment {
            commentObjectType
            text
            author
            parentCommentId
          }
          errors
        }
      }
    GQL
  end

  it 'creates comment' do
    create(:user, id: 1, username: "username")

    result = execute_graphql(
      mutation,
      variables: { commentId: "d10a77ac-8ed5-4778-ad9d-6f0d51711b30", commentObjectType: 'PRODUCT',
                   commentObjectId: 1, text: 'Some comment', userId: 1, parentCommentId: nil },
    )

    aggregate_failures do
      expect(result['data']['createComment']['comment'])
        .to(eq({ "commentObjectType" => "PRODUCT",
                 "parentCommentId" => nil,
                 "text" => "Some comment",
                 "author" => { "id" => 1,
                               "username" => "username" } }))
      expect(result['data']['createComment']['errors'])
        .to(eq([]))
    end
  end

  it 'creates reply' do
    create(:user, id: 1, username: "username")
    create(:product, id: 1, name: "test", slug: "test")
    create(:comment, id: 5, comment_id: "be01ea21-a13a-4d97-8218-250c2ab9ef40", comment_object_type: 'PRODUCT',
                     comment_object_id: 1, text: 'Some comment',
                     author: { "id": 1, "username": "username" })

    result = execute_graphql(
      mutation,
      variables: { commentId: "3eb0da0f-2d13-4d96-b350-7ce49a80f088", commentObjectType: 'PRODUCT',
                   commentObjectId: 1, text: 'Some reply', userId: 1,
                   parentCommentId: "be01ea21-a13a-4d97-8218-250c2ab9ef40" },
    )

    aggregate_failures do
      expect(result['data']['createComment']['comment'])
        .to(eq({ "commentObjectType" => "PRODUCT",
                 "parentCommentId" => "be01ea21-a13a-4d97-8218-250c2ab9ef40",
                 "text" => "Some reply",
                 "author" => { "id" => 1,
                               "username" => "username" } }))
      expect(result['data']['createComment']['errors'])
        .to(eq([]))
    end
  end

  it 'updates comment' do
    create(:comment, comment_id: "d10a77ac-8ed5-4778-ad9d-6f0d51711b30", comment_object_type: 'PRODUCT',
                     comment_object_id: 1, text: 'Some comment',
                     author: { "id": 5, "username": "username5" })

    result = execute_graphql(
      mutation,
      variables: { commentId: "d10a77ac-8ed5-4778-ad9d-6f0d51711b30", commentObjectType: 'PRODUCT',
                   commentObjectId: 1, text: 'Some updated comment', userId: 1, parentCommentId: nil },
    )

    aggregate_failures do
      expect(result['data']['createComment']['comment'])
        .to(eq({ "commentObjectType" => "PRODUCT",
                 "parentCommentId" => nil,
                 "text" => "Some updated comment",
                 "author" => { "id" => 5,
                               "username" => "username5" } }))
      expect(result['data']['createComment']['errors'])
        .to(eq([]))
    end
  end
end
