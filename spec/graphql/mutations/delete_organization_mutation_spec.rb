# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteOrganization, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteOrganization (
        $id: ID!
        ) {
        deleteOrganization(
          id: $id
        ) {
            organization
            {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:organization, id: 1000, name: 'Some Org', slug: 'some_org', website: 'some.org', countries: [], sectors: [])
    expect_any_instance_of(Mutations::DeleteOrganization).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteOrganization']['organization'])
        .to(be(nil))
      expect(result['data']['deleteOrganization']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:organization, id: 1000, name: 'Some Org', slug: 'some_org', website: 'some.org', countries: [], sectors: [])

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteOrganization']['organization'])
        .to(be(nil))
      expect(result['data']['deleteOrganization']['errors'])
        .to(eq(["Must be admin to delete an organization"]))
    end
  end
end
