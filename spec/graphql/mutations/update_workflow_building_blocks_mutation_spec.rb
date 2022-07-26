# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateWorkflowBuildingBlocks, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateWorkflowBuildingBlocks (
        $buildingBlocksSlugs: [String!]!
        $slug: String!
        ) {
          updateWorkflowBuildingBlocks (
            buildingBlocksSlugs: $buildingBlocksSlugs
            slug: $slug
          ) {
            workflow {
              slug
              buildingBlocks {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:workflow, name: 'Some Name', slug: 'some_name',
                           building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')
    expect_any_instance_of(Mutations::UpdateWorkflowBuildingBlocks).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { buildingBlocksSlugs: ['bb_2', 'bb_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow'])
        .to(eq({ "slug" => "some_name", "buildingBlocks" => [{ "slug" => "bb_2" }, { "slug" => "bb_3" }] }))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:workflow, name: 'Some Name', slug: 'some_name',
                           building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')
    expect_any_instance_of(Mutations::UpdateWorkflowBuildingBlocks).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { buildingBlocksSlugs: ['bb_2', 'bb_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow'])
        .to(eq({ "slug" => "some_name", "buildingBlocks" => [{ "slug" => "bb_2" }, { "slug" => "bb_3" }] }))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    expect_any_instance_of(Mutations::UpdateWorkflowBuildingBlocks).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateWorkflowBuildingBlocks).to(receive(:a_content_editor).and_return(false))

    create(:workflow, name: 'Some Name', slug: 'some_name',
                           building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')

    result = execute_graphql(
      mutation,
      variables: { buildingBlocksSlugs: ['bb_2', 'bb_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow'])
        .to(eq(nil))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors'])
        .to(eq(['Must be admin or content editor to update workflow']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:workflow, name: 'Some Name', slug: 'some_name',
                           building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')

    result = execute_graphql(
      mutation,
      variables: { buildingBlocksSlugs: ['bb_2', 'bb_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow'])
        .to(eq(nil))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors'])
        .to(eq(['Must be admin or content editor to update workflow']))
    end
  end
end
