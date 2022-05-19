# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationSectors, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($sectorsSlugs: [String!]!, $slug: String!) {
        updateOrganizationSectors(
          sectorsSlugs: $sectorsSlugs
          slug: $slug
        ) {
          organization {
            slug
            sectors {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'is successful' do
    country1 = create(:country, slug: 'c1', name: 'country1', code: 'cc1', code_longer: 'ccl1', latitude: 35.5,
    longitude: 41.1)

    origin3 = create(:origin, slug: 'o3')
    origin2 = create(:origin, slug: 'o2')
    origin1 = create(:origin, slug: 'o1')

    sector3 = create(:sector, slug: 's3', name: 'sector3', origin: origin3)

    create(:sector, slug: 's2', name: 'sector2', origin: origin2)
    create(:sector, slug: 's1', name: 'sector1', origin: origin1)

    organization = create(:organization, slug: 'org1', name: 'organization1', sectors: [sector3], countries: [country1])

    result = execute_graphql(
      mutation,
      variables: { sectorsSlugs: ['s1', 's2'], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationSectors']['organization'])
        .to(eq({ "sectors" => [{ "slug" => "s2" }, { "slug" => "s1" }], "slug" => "org1" }))
    end
  end
end
