# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectSectors, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProjectSectors (
        $sectorsSlugs: [String!]!
        $slug: String!
        ) {
          updateProjectSectors (
            sectorsSlugs: $sectorsSlugs
            slug: $slug
          ) {
            project {
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

  it 'is successful - user is logged in as admin' do
    create(:project, name: 'Some Name', slug: 'some_name', sectors: [create(:sector, slug: 'sec_1', name: 'Sec 1')])
    create(:sector, slug: 'sec_2', name: 'Sec 2')
    create(:sector, slug: 'sec_3', name: 'Sec 3')
    expect_any_instance_of(Mutations::UpdateProjectSectors).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { sectorsSlugs: ['sec_2', 'sec_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project'])
        .to(eq({ "slug" => "some_name", "sectors" => [{ "slug" => "sec_2" }, { "slug" => "sec_3" }] }))
      expect(result['data']['updateProjectSectors']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(:project, name: 'Some Name', slug: 'some_name', sectors: [create(:sector, slug: 'sec_1', name: 'Sec 1')],
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')],
                     products: [create(:product, id: 1)])
    create(:sector, slug: 'sec_2', name: 'Sec 2')
    create(:sector, slug: 'sec_3', name: 'Sec 3')
    expect_any_instance_of(Mutations::UpdateProjectSectors).to(receive(:product_owner_check_for_project)
      .and_return(true))

    result = execute_graphql(
      mutation,
      variables: { sectorsSlugs: ['sec_2', 'sec_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project'])
        .to(eq({ "slug" => "some_name", "sectors" => [{ "slug" => "sec_2" }, { "slug" => "sec_3" }] }))
      expect(result['data']['updateProjectSectors']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:project, name: 'Some Name', slug: 'some_name', sectors: [create(:sector, slug: 'sec_1', name: 'Sec 1')],
                     organizations: [create(:organization, slug: 'org_1', name: 'Org 1')],
                     products: [create(:product, id: 1)])
    create(:sector, slug: 'sec_2', name: 'Sec 2')
    create(:sector, slug: 'sec_3', name: 'Sec 3')
    expect_any_instance_of(Mutations::UpdateProjectSectors).to(receive(:org_owner_check_for_project).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { sectorsSlugs: ['sec_2', 'sec_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project'])
        .to(eq({ "slug" => "some_name", "sectors" => [{ "slug" => "sec_2" }, { "slug" => "sec_3" }] }))
      expect(result['data']['updateProjectSectors']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:project, name: 'Some Name', slug: 'some_name', sectors: [create(:sector, slug: 'sec_1', name: 'Sec 1')])
    create(:sector, slug: 'sec_2', name: 'Sec 2')
    create(:sector, slug: 'sec_3', name: 'Sec 3')

    result = execute_graphql(
      mutation,
      variables: { sectorsSlugs: ['sec_2', 'sec_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project'])
        .to(eq(nil))
      expect(result['data']['updateProjectSectors']['errors'])
        .to(eq(['Must have proper rights to update a project']))
    end
  end
end
