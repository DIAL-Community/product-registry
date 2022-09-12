# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateRubricCategory, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateRubricCategory (
        $name: String!
        $slug: String!
        $weight: Float!
        $description: String!
        ) {
        createRubricCategory(
          name: $name
          slug: $slug
          weight: $weight
          description: $description
        ) {
            rubricCategory
            {
              name
              slug
              weight
              rubricCategoryDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates rubric category - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateRubricCategory).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", weight: 0.75,
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(eq({ "name" => "Some name", "slug" => "some_name", "weight" => 0.75,
                 "rubricCategoryDescription" => { "description" => "some description" } }))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq([]))
    end
  end

  it 'updates a name without changing slug' do
    expect_any_instance_of(Mutations::CreateRubricCategory).to(receive(:an_admin).and_return(true))
    create(:rubric_category, name: "Some name", slug: "some_name")

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name", weight: 0.6,
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name", "weight" => 0.6,
                 "rubricCategoryDescription" => { "description" => "some description" } }))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreateRubricCategory).to(receive(:an_admin).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", weight: 0.75,
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(be(nil))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq(['Must be admin to create a rubric category']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", weight: 0.75,
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(be(nil))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq(['Must be admin to create a rubric category']))
    end
  end
end
