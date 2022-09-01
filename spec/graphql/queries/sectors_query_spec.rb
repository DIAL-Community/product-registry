# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::SectorsQuery, type: :graphql) do
  let(:sector_query) do
    <<~GQL
      query SearchSectors(
        $first: Int
        $after: String
        $search: String
        $locale: String
        $parentSectorId: Int
        $isDisplayable: Boolean
      ) {
        searchSectors(
          first: $first
          after: $after
          search: $search
          locale: $locale
          parentSectorId: $parentSectorId
          isDisplayable: $isDisplayable
        ) {
          totalCount
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
          }
          nodes {
            name
            locale
            parentSectorId
            isDisplayable
          }
        }
      }
    GQL
  end

  it 'pulling all sectors.' do
    create(:sector, id: 1001, name: 'Sector A', slug: 'sector_a', is_displayable: true)
    create(:sector, id: 1002, name: 'Sector B', slug: 'sector_b', is_displayable: false)
    result = execute_graphql(
      sector_query
    )

    aggregate_failures do
      # 2 sectors from here, 2 from fixtures
      expect(result['data']['searchSectors']['totalCount']).to(eq(4))
    end

    # Passing parameter to search will filter search result.
    result = execute_graphql(
      sector_query,
      variables: { search: 'Sector A' },
    )

    aggregate_failures do
      expect(result['data']['searchSectors']['totalCount']).to(eq(1))
      expect(result['data']['searchSectors']['nodes'])
        .to(eq([{ 'name' => 'Sector A', 'locale' => 'en', 'parentSectorId' => nil, 'isDisplayable' => true }]))
    end
  end

  it 'pulling displayable sectors.' do
    create(:sector, id: 1001, name: 'Sector A', slug: 'sector_a', is_displayable: true)
    create(:sector, id: 1002, name: 'Sector B', slug: 'sector_b', is_displayable: false)
    result = execute_graphql(
      sector_query,
      variables: { isDisplayable: true }
    )

    aggregate_failures do
      expect(result['data']['searchSectors']['totalCount']).to(eq(1))
      expect(result['data']['searchSectors']['nodes'])
        .to(eq([{ 'name' => 'Sector A', 'locale' => 'en', 'parentSectorId' => nil, 'isDisplayable' => true }]))
    end

    result = execute_graphql(
      sector_query,
      variables: { isDisplayable: false }
    )

    aggregate_failures do
      expect(result['data']['searchSectors']['totalCount']).to(eq(1))
      expect(result['data']['searchSectors']['nodes'])
        .to(eq([{ 'name' => 'Sector B', 'locale' => 'en', 'parentSectorId' => nil, 'isDisplayable' => false }]))
    end
  end

  it 'pulling sectors based on the locale value.' do
    create(:sector, id: 1001, name: 'Sector A', slug: 'sector_a', is_displayable: true, locale: 'de')
    create(:sector, id: 1002, name: 'Sector B', slug: 'sector_b', is_displayable: false, locale: 'es')
    result = execute_graphql(
      sector_query,
      variables: { locale: 'de' }
    )

    aggregate_failures do
      expect(result['data']['searchSectors']['totalCount']).to(eq(1))
      expect(result['data']['searchSectors']['nodes'])
        .to(eq([{ 'name' => 'Sector A', 'locale' => 'de', 'parentSectorId' => nil, 'isDisplayable' => true }]))
    end

    result = execute_graphql(
      sector_query,
      variables: { locale: 'es' }
    )

    aggregate_failures do
      expect(result['data']['searchSectors']['totalCount']).to(eq(1))
      expect(result['data']['searchSectors']['nodes'])
        .to(eq([{ 'name' => 'Sector B', 'locale' => 'es', 'parentSectorId' => nil, 'isDisplayable' => false }]))
    end
  end

  it 'pulling sectors based on the locale value.' do
    create(:sector, id: 1001, name: 'Sector A', slug: 'sector_a', is_displayable: true)
    create(:sector, id: 1002, name: 'Sector B', slug: 'sector_b', is_displayable: false, parent_sector_id: 1001)
    result = execute_graphql(
      sector_query,
      variables: { parentSectorId: 1001 }
    )

    aggregate_failures do
      expect(result['data']['searchSectors']['totalCount']).to(eq(1))
      expect(result['data']['searchSectors']['nodes'])
        .to(eq([{ 'name' => 'Sector B', 'locale' => 'en', 'parentSectorId' => "1001", 'isDisplayable' => false }]))
    end

    result = execute_graphql(
      sector_query,
      variables: { parentSectorId: 1001, search: 'Sector C' }
    )

    aggregate_failures do
      expect(result['data']['searchSectors']['totalCount']).to(eq(0))
    end
  end
end
