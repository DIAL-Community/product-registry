# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateBuildingBlock, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateBuildingBlock (
        $name: String!
        $slug: String!
        $description: String!
        $maturity: String!
        $specUrl: String
        ) {
        createBuildingBlock(
          name: $name
          slug: $slug
          description: $description
          maturity: $maturity
          specUrl: $specUrl
        ) {
            buildingBlock
            {
              name
              slug
              buildingBlockDescription {
                description
              }
              maturity
              specUrl
            }
            errors
          }
        }
    GQL
  end

  it 'creates building block - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateBuildingBlock).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", maturity: "PUBLISHED",
                   specUrl: "some.url" },
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "buildingBlockDescription" => { "description" => "some description" },
                 "maturity" => "PUBLISHED", "specUrl" => "some.url" }))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq([]))
    end
  end

  it 'creates building block - user is logged in as content editor' do
    expect_any_instance_of(Mutations::CreateBuildingBlock).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", maturity: "BETA",
                   specUrl: "some.url" },
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "buildingBlockDescription" => { "description" => "some description" },
                 "maturity" => "BETA", "specUrl" => "some.url" }))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq([]))
    end
  end

  it 'updates name for existing method matched by slug' do
    expect_any_instance_of(Mutations::CreateBuildingBlock).to(receive(:an_admin).and_return(true))
    create(:building_block, name: "Some name", slug: "some_name")

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name", description: "some description",
                   maturity: "BETA", specUrl: "some.url" },
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name",
                 "buildingBlockDescription" => { "description" => "some description" },
                 "maturity" => "BETA", "specUrl" => "some.url" }))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq([]))
    end
  end

  it 'generate offset for new building block with duplicated name' do
    expect_any_instance_of(Mutations::CreateBuildingBlock).to(receive(:an_admin).and_return(true))
    create(:building_block, name: "Some name", slug: "some_name")

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", maturity: "BETA",
                   specUrl: "some.url" },
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({ "name" => "Some name", "slug" => "some_name_dup0",
                 "buildingBlockDescription" => { "description" => "some description" },
                 "maturity" => "BETA", "specUrl" => "some.url" }))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreateBuildingBlock).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::CreateBuildingBlock).to(receive(:a_content_editor).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", maturity: "BETA",
                   specUrl: "some.url" },
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(be(nil))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq(['Must be admin or content editor to create building block']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", maturity: "BETA",
                   specUrl: "some.url" },
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(be(nil))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq(['Must be admin or content editor to create building block']))
    end
  end
end
