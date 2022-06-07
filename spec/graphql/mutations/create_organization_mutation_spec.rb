# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateOrganization, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateOrganization(
        $name: String!,
        $slug: String!
        ) {
        createOrganization(
          name: $name,
          slug: $slug,
          aliases: {},
          website: "somewebsite.org",
          isMni: false,
          whenEndorsed: "2022-01-01",
          endorserLevel: "none",
          description: ""
        ) {
            organization
            {
              name
              slug
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    expect_any_instance_of(Mutations::CreateOrganization).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name" },
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({ "name" => "Some name", "slug" => "some_name" }))
    end
  end

  it 'is successful - organization owner can update organization name and slug remains the same' do
    create(:organization, name: "Some name", slug: "some_name", website: "some.website.com")
    expect_any_instance_of(Mutations::CreateOrganization).to(receive(:an_org_owner).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name" },
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name" }))
    end
  end

  it 'is successful - admin can update organization name and slug remains the same' do
    create(:organization, name: "Some name", slug: "some_name", website: "some.website.com")
    expect_any_instance_of(Mutations::CreateOrganization).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some_name" },
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name" }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name" },
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(be(nil))
    end
  end
end
