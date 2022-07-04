# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateUseCase, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateUseCase (
        $name: String!
        $slug: String!
        $sectorSlug: String!
        $maturity: String!
        $description: String!
        ) {
        createUseCase(
          name: $name
          slug: $slug
          sectorSlug: $sectorSlug
          maturity: $maturity
          description: $description
        ) {
            useCase
            {
              name
              slug
              sector {
                slug
              }
              maturity
              useCaseDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates use case - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateUseCase).to(receive(:an_admin).and_return(true))
    create(:sector, slug: 'sec_1', name: 'Sec 1')

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", sectorSlug: "sec_1", maturity: "BETA",
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(eq({ "name" => "Some name", "slug" => "some_name", "sector" => { "slug" => "sec_1" },
                 "maturity" => "BETA",
                 "useCaseDescription" => { "description" => "some description" } }))
      expect(result['data']['createUseCase']['errors'])
        .to(eq([]))
    end
  end

  it 'creates use case - user is logged in as content editor' do
    expect_any_instance_of(Mutations::CreateUseCase).to(receive(:a_content_editor).and_return(true))
    create(:sector, slug: 'sec_1', name: 'Sec 1')

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", sectorSlug: "sec_1", maturity: "BETA",
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(eq({ "name" => "Some name", "slug" => "some_name", "sector" => { "slug" => "sec_1" },
                 "maturity" => "BETA",
                 "useCaseDescription" => { "description" => "some description" } }))
      expect(result['data']['createUseCase']['errors'])
        .to(eq([]))
    end
  end

  it 'updates a name without changing slug' do
    expect_any_instance_of(Mutations::CreateUseCase).to(receive(:an_admin).and_return(true))
    create(:use_case, name: "Some name", slug: "some_name")
    create(:sector, slug: 'sec_1', name: 'Sec 1')

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name", sectorSlug: "sec_1", maturity: "BETA",
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name", "sector" => { "slug" => "sec_1" },
                 "maturity" => "BETA",
                 "useCaseDescription" => { "description" => "some description" } }))
      expect(result['data']['createUseCase']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreateUseCase).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::CreateUseCase).to(receive(:a_content_editor).and_return(false))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", sectorSlug: "sec_1", maturity: "BETA",
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(be(nil))
      expect(result['data']['createUseCase']['errors'])
        .to(eq(['Must be admin or content editor to create an use case']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", sectorSlug: "sec_1", maturity: "BETA",
                   description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(be(nil))
      expect(result['data']['createUseCase']['errors'])
        .to(eq(['Must be admin or content editor to create an use case']))
    end
  end
end
