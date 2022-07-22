# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateWorkflow, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateWorkflow (
        $name: String!
        $slug: String!
        $description: String!
        ) {
        createWorkflow(
          name: $name
          slug: $slug
          description: $description
        ) {
            workflow
            {
              name
              slug
              workflowDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates use case - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateWorkflow).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'creates use case - user is logged in as content editor' do
    expect_any_instance_of(Mutations::CreateWorkflow).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'updates name for existing method matched by slug' do
    expect_any_instance_of(Mutations::CreateWorkflow).to(receive(:an_admin).and_return(true))
    create(:workflow, name: "Some name", slug: "some_name")

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'generate offset for new use case with duplicated name' do
    expect_any_instance_of(Mutations::CreateWorkflow).to(receive(:an_admin).and_return(true))
    create(:workflow, name: "Some name", slug: "some_name")

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some name", "slug" => "some_name_dup0",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreateWorkflow).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::CreateWorkflow).to(receive(:a_content_editor).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(be(nil))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq(['Must be admin or content editor to create workflow']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(be(nil))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq(['Must be admin or content editor to create workflow']))
    end
  end
end
