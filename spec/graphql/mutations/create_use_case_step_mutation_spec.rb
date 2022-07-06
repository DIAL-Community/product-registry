# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateUseCaseStep, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateUseCaseStep (
        $name: String!
        $slug: String!
        $description: String!
        $stepNumber: Int!
        $useCaseId: Int!
        ) {
        createUseCaseStep(
          name: $name
          slug: $slug
          description: $description
          stepNumber: $stepNumber
          useCaseId: $useCaseId
        ) {
            useCaseStep
            {
              name
              slug
              useCaseStepDescription {
                description
              }
              stepNumber
              useCase {
                id
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates use case - user is logged in as admin' do
    create(:use_case, id: 3)
    expect_any_instance_of(Mutations::CreateUseCaseStep).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", stepNumber: 5, useCaseId: 3 },
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "useCaseStepDescription" => { "description" => "some description" },
                 "stepNumber" => 5, "useCase" => { "id" => "3" } }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'creates use case - user is logged in as content editor' do
    create(:use_case, id: 3)
    expect_any_instance_of(Mutations::CreateUseCaseStep).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", stepNumber: 5, useCaseId: 3 },
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({ "name" => "Some name", "slug" => "some_name",
                 "useCaseStepDescription" => { "description" => "some description" },
                 "stepNumber" => 5, "useCase" => { "id" => "3" } }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'updates name for existing method matched by slug' do
    expect_any_instance_of(Mutations::CreateUseCaseStep).to(receive(:an_admin).and_return(true))
    create(:use_case, id: 3)
    create(:use_case_step, name: "Some name", slug: "some_name", step_number: 5)

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name", description: "some description", stepNumber: 5,
                   useCaseId: 3 },
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name",
                 "useCaseStepDescription" => { "description" => "some description" },
                 "stepNumber" => 5, "useCase" => { "id" => "3" } }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'generate offset for new use case with duplicated name' do
    expect_any_instance_of(Mutations::CreateUseCaseStep).to(receive(:an_admin).and_return(true))
    create(:use_case, id: 3)
    create(:use_case_step, name: "Some name", slug: "some_name", step_number: 5)

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", stepNumber: 5,
                   useCaseId: 3 },
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({ "name" => "Some name", "slug" => "some_name_dup0",
                 "useCaseStepDescription" => { "description" => "some description" },
                 "stepNumber" => 5, "useCase" => { "id" => "3" } }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreateUseCaseStep).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::CreateUseCaseStep).to(receive(:a_content_editor).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", stepNumber: 5, useCaseId: 3 },
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(be(nil))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq(['Must be admin or content editor to create an use case step']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", stepNumber: 5, useCaseId: 3 },
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(be(nil))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq(['Must be admin or content editor to create an use case step']))
    end
  end
end
