# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationProjects, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($projectsSlugs: [String!]!, $slug: String!) {
        updateOrganizationProjects(
          projectsSlugs: $projectsSlugs
          slug: $slug
        ) {
          organization {
            slug
            projects {
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

    project3 = create(:project, slug: 'p3', name: 'project3', origin: origin3)

    create(:project, slug: 'p2', name: 'project2', origin: origin2)
    create(:project, slug: 'p1', name: 'project1', origin: origin1)

    sector = create(:sector, slug: 's', name: 'sector', origin: origin3)

    organization = create(:organization, slug: 'org1', name: 'organization1', projects: [project3],
      countries: [country1], sectors: [sector])

    result = execute_graphql(
      mutation,
      variables: { projectsSlugs: ['p1', 'p2'], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationProjects']['organization'])
        .to(eq({ "projects" => [{ "slug" => "p1" }, { "slug" => "p2" }], "slug" => "org1" }))
    end
  end
end
