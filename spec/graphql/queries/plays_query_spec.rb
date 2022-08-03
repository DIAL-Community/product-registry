# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::PlaysQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query {
        plays {
          id
          slug
          name
        }
      }
    GQL
  end

  it 'pulling plays is successful' do
    create(:play, name: 'Some Play')
    create(:play, name: 'Some More Play')
    create(:play, name: 'Yet More Play')
    create(:play, name: 'Another Play')

    result = execute_graphql(
      query
    )

    aggregate_failures do
      expect(result['data']['plays'].count)
        .to(eq(4))
    end
  end
end

RSpec.describe(Queries::SearchPlaysQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query
        SearchPlays(
          $search: String
          $products: [String!]
          $after: String
          $before: String
          $first: Int
          $last: Int
        ) {
          searchPlays (
            search: $search
            products: $products
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
              name
            }
          }
        }
    GQL
  end

  it 'searching plays is successful' do
    create(:play, name: 'Some Play')

    result = execute_graphql(
      query,
      variables: { "search": "Some" }
    )

    aggregate_failures do
      expect(result['data']['searchPlays']['totalCount']).to(eq(1))
    end
  end

  it 'searching plays fails' do
    result = execute_graphql(
      query,
      variables: { search: "Whatever which does not exist" }
    )

    aggregate_failures do
      expect(result['data']['searchPlays']['totalCount']).to(eq(0))
    end
  end
end
