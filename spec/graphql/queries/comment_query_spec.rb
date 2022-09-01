# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::CommentsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query Comments(
          $commentObjectType: String!,
          $commentObjectId: Int!) {
        comments(
          commentObjectType: $commentObjectType,
          commentObjectId: $commentObjectId) {
          userId
          comId
          fullName
          avatarUrl
          text
        }
      }
    GQL
  end

  it 'pulls correct comment' do
    create(:comment, id: 5, comment_id: "be01ea21-a13a-4d97-8218-250c2ab9ef40", comment_object_type: 'PRODUCT',
                     comment_object_id: 1, text: 'Some comment',
                     author: { "id": 1, "username": "username" })
    result = execute_graphql(
      query,
      variables: {
        commentObjectType: "PRODUCT",
        commentObjectId: 1
      }
    )

    aggregate_failures do
      expect(result['data']['comments']).to(eq([{ "avatarUrl" => "https://ui-avatars.com/api/name=username&background=random",
                                                  "comId" => "be01ea21-a13a-4d97-8218-250c2ab9ef40",
                                                  "fullName" => "username",
                                                  "text" => "Some comment",
                                                  "userId" => "1" }]))
    end
  end

  it 'pulls empty array if comment does not exist' do
    result = execute_graphql(
      query,
      variables: {
        commentObjectType: "PRODUCT",
        commentObjectId: 1
      }
    )

    aggregate_failures do
      expect(result['data']['comments']).to(eq([]))
    end
  end
end
