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
    first = create(:sector, slug: 'first_sector', name: 'First Sector', is_displayable: true)
    second = create(:sector, slug: 'second_sector', name: 'Second Sector', is_displayable: true)

    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')
    expect_any_instance_of(Mutations::UpdateOrganizationSectors).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { sectorsSlugs: [first.slug, second.slug], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationSectors']['organization'])
        .to(eq({ "sectors" => [{ "slug" => first.slug }, { "slug" => second.slug }], "slug" => organization.slug }))
    end
  end
end
