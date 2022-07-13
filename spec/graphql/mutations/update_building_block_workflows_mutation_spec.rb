# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateBuildingBlockWorkflows, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateBuildingBlockWorkflows (
        $workflowsSlugs: [String!]!
        $slug: String!
        ) {
          updateBuildingBlockWorkflows (
            workflowsSlugs: $workflowsSlugs
            slug: $slug
          ) {
            buildingBlock {
              slug
              workflows {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:building_block, name: 'Some Name', slug: 'some_name',
                      workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')
    expect_any_instance_of(Mutations::UpdateBuildingBlockWorkflows).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq({ "slug" => "some_name", "workflows" => [{ "slug" => "wf_2" }, { "slug" => "wf_3" }] }))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:building_block, name: 'Some Name', slug: 'some_name',
                      workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')
    expect_any_instance_of(Mutations::UpdateBuildingBlockWorkflows).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq({ "slug" => "some_name", "workflows" => [{ "slug" => "wf_2" }, { "slug" => "wf_3" }] }))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    expect_any_instance_of(Mutations::UpdateBuildingBlockWorkflows).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateBuildingBlockWorkflows).to(receive(:a_content_editor).and_return(false))

    create(:building_block, name: 'Some Name', slug: 'some_name',
                     workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq(nil))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq(['Must be admin or content editor to update building block']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:building_block, name: 'Some Name', slug: 'some_name',
                     workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq(nil))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq(['Must be admin or content editor to update building block']))
    end
  end
end
