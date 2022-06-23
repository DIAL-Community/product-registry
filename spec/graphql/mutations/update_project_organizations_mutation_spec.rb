# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectOrganizations, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProjectOrganizations (
        $organizationsSlugs: [String!]!
        $slug: String!
        ) {
          updateProjectOrganizations (
            organizationsSlugs: $organizationsSlugs
            slug: $slug
          ) {
            project {
              slug
              organizations {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:project, name: 'Some Name', slug: 'some_name',
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')])
    create(:organization, slug: 'org_2', name: 'Org 2')
    create(:organization, slug: 'org_3', name: 'Org 3')
    expect_any_instance_of(Mutations::UpdateProjectOrganizations).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { organizationsSlugs: ['org_2', 'org_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectOrganizations']['project'])
        .to(eq({ "slug" => "some_name", "organizations" => [{ "slug" => "org_2" }, { "slug" => "org_3" }] }))
      expect(result['data']['updateProjectOrganizations']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(:project, name: 'Some Name', slug: 'some_name',
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')],
                     products: [create(:product, id: 1)])
    create(:organization, slug: 'org_2', name: 'Org 2')
    create(:organization, slug: 'org_3', name: 'Org 3')
    expect_any_instance_of(Mutations::UpdateProjectOrganizations).to(receive(:product_owner_check).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { organizationsSlugs: ['org_2', 'org_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectOrganizations']['project'])
        .to(eq({ "slug" => "some_name", "organizations" => [{ "slug" => "org_2" }, { "slug" => "org_3" }] }))
      expect(result['data']['updateProjectOrganizations']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:project, name: 'Some Name', slug: 'some_name',
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')],
                     products: [create(:product, id: 1)])
    create(:organization, slug: 'org_2', name: 'Org 2')
    create(:organization, slug: 'org_3', name: 'Org 3')
    expect_any_instance_of(Mutations::UpdateProjectOrganizations).to(receive(:org_owner_check).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { organizationsSlugs: ['org_2', 'org_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectOrganizations']['project'])
        .to(eq({ "slug" => "some_name", "organizations" => [{ "slug" => "org_2" }, { "slug" => "org_3" }] }))
      expect(result['data']['updateProjectOrganizations']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:project, name: 'Some Name', slug: 'some_name',
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')])
    create(:organization, slug: 'org_2', name: 'Org 2')
    create(:organization, slug: 'org_3', name: 'Org 3')

    result = execute_graphql(
      mutation,
      variables: { organizationsSlugs: ['org_2', 'org_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectOrganizations']['project'])
        .to(eq(nil))
      expect(result['data']['updateProjectOrganizations']['errors'])
        .to(eq(['Must have proper rights to update a project']))
    end
  end
end
