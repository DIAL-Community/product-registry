# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteCountry, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteCountry ($id: ID!) {
        deleteCountry(id: $id) {
            country {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:country, id: 1000, name: 'Some Country', slug: 'some_country')
    expect_any_instance_of(Mutations::DeleteCountry).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteCountry']['country'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteCountry']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:country, id: 1000, name: 'Some Country', slug: 'some_country')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteCountry']['country'])
        .to(be(nil))
      expect(result['data']['deleteCountry']['errors'])
        .to(eq(["Must be admin to delete a country."]))
    end
  end
end
