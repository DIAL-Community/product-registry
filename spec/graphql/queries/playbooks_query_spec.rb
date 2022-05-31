# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::PlaybooksQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query {
        playbooks{
          id
          slug
          author
          name
        }
      }
    GQL
  end

  it 'pulling playbooks is successful' do
    result = execute_graphql(
      query
    )

    aggregate_failures do
      expect(result['data']['playbooks'].count)
        .to(eq(4))
    end
  end
end

RSpec.describe(Queries::SearchPlaybooksQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query
        SearchPlaybooks(
          $search: String
          $products: [String!]
          $tags: [String!]
          $after: String
          $before: String
          $first: Int
          $last: Int
        ) {
          searchPlaybooks (
            search: $search
            products: $products
            tags: $tags
            after: $after
            before: $before
            first: $first
            last: $last
          ) {
            totalCount
            pageInfo {
              endCursor
              startCursor
              hasPreviousPage
              hasNextPage
            }
            nodes {
              id
              slug
              author
              name
              draft
            }
          }
        }
    GQL
  end

  it 'searches only published playbooks for not logged users' do
    create(:playbook, name: 'Some Published Playbook', author: nil, draft: false, id: 1000)
    create(:playbook, name: 'Some Draft Playbook', author: nil, draft: true, id: 1001)

    result = execute_graphql(
      query,
      variables: { "search": "Some" }
    )

    aggregate_failures do
      expect(result['data']['searchPlaybooks']['totalCount']).to(eq(1))
    end
  end

  it 'searches published and drafted playbooks for admin' do
    expect_any_instance_of(Queries::SearchPlaybooksQuery).to(receive(:an_admin).and_return(true))

    create(:playbook, name: 'Some Published Playbook', author: nil, draft: false, id: 1000)
    create(:playbook, name: 'Some Draft Playbook', author: nil, draft: true, id: 1001)

    result = execute_graphql(
      query,
      variables: { "search": "Some" }
    )

    aggregate_failures do
      expect(result['data']['searchPlaybooks']['totalCount']).to(eq(2))
    end
  end
end
