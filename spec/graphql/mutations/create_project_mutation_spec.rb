# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateProject, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateProject (
        $name: String!
        $slug: String!
        $description: String!
        ) {
        createProject(
          name: $name
          slug: $slug
          description: $description
          productId: null
          organizationId: null
        ) {
            project
            {
              name
              slug
              projectDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateProject).to(receive(:an_admin).and_return(true))
    create(:origin, slug: 'manually_entered')

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createProject']['project'])
        .to(eq({ "name" => "Some name", "projectDescription" => { "description" => "some description" },
                 "slug" => "some_name" }))
      expect(result['data']['createProject']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - admin can update project name and slug remains the same' do
    create(:project, name: "Some name", slug: "some_name")
    create(:origin, slug: 'manually_entered')
    expect_any_instance_of(Mutations::CreateProject).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createProject']['project'])
        .to(eq({ "name" => "Some new name", "projectDescription" => { "description" => "some description" },
                 "slug" => "some_name" }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name", description: "some description" }
    )

    aggregate_failures do
      expect(result['data']['createProject']['project'])
        .to(be(nil))
      expect(result['data']['createProject']['errors'])
        .to(eq(['Must be admin, product owner or organization owner to create a project']))
    end
  end
end
