# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteComment, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteComment (
        $commentId: String!
        ) {
        deleteComment(
          commentId: $commentId
        ) {
            comment
            {
              commentId
            }
            errors
          }
        }
    GQL
  end

  it 'deletes comment successfully - user is a comment author' do
    create(:comment, id: 5, comment_id: "be01ea21-a13a-4d97-8218-250c2ab9ef40", comment_object_type: 'PRODUCT',
                     comment_object_id: 1, text: 'Some comment',
                     author: { "id": 1, "username": "username" })
    expect_any_instance_of(Mutations::DeleteComment).to(receive(:a_comment_author).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { commentId: "be01ea21-a13a-4d97-8218-250c2ab9ef40" },
    )

    aggregate_failures do
      expect(result['data']['deleteComment']['comment'])
        .to(be(nil))
      expect(result['data']['deleteComment']['errors'])
        .to(eq([]))
    end
  end

  it 'deletes comment and its replies successfully - user is an admin' do
    create(:comment, id: 5, comment_id: "be01ea21-a13a-4d97-8218-250c2ab9ef40", comment_object_type: 'PRODUCT',
                     comment_object_id: 1, text: 'Some comment',
                     author: { "id": 1, "username": "username" })
    create(:comment, id: 6, comment_id: "abc1ea21-a13a-4d97-8218-250c2ab9ef40", comment_object_type: 'PRODUCT',
                     comment_object_id: 1, text: 'Some comment',
                     parent_comment_id: "be01ea21-a13a-4d97-8218-250c2ab9ef40",
                     author: { "id": 1, "username": "username" })
    expect_any_instance_of(Mutations::DeleteComment).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { commentId: "be01ea21-a13a-4d97-8218-250c2ab9ef40" },
    )

    aggregate_failures do
      expect(result['data']['deleteComment']['comment'])
        .to(be(nil))
      expect(result['data']['deleteComment']['errors'])
        .to(eq([]))
    end
  end
end
