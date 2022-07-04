# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseStepWorkflows, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseStepWorkflows (
        $workflowsSlugs: [String!]!
        $slug: String!
        ) {
          updateUseCaseStepWorkflows (
            workflowsSlugs: $workflowsSlugs
            slug: $slug
          ) {
            useCaseStep {
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
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                      workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')
    expect_any_instance_of(Mutations::UpdateUseCaseStepWorkflows).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep'])
        .to(eq({ "slug" => "some_name", "workflows" => [{ "slug" => "wf_2" }, { "slug" => "wf_3" }] }))
      expect(result['data']['updateUseCaseStepWorkflows']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                      workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')
    expect_any_instance_of(Mutations::UpdateUseCaseStepWorkflows).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep'])
        .to(eq({ "slug" => "some_name", "workflows" => [{ "slug" => "wf_2" }, { "slug" => "wf_3" }] }))
      expect(result['data']['updateUseCaseStepWorkflows']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    expect_any_instance_of(Mutations::UpdateUseCaseStepWorkflows).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateUseCaseStepWorkflows).to(receive(:a_content_editor).and_return(false))

    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                     workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseStepWorkflows']['errors'])
        .to(eq(['Must be an admin or content editor to update use case step']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                     workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql(
      mutation,
      variables: { workflowsSlugs: ['wf_2', 'wf_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseStepWorkflows']['errors'])
        .to(eq(['Must be an admin or content editor to update use case step']))
    end
  end
end
