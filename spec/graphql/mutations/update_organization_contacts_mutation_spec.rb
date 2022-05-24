# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationCountry, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($contacts: JSON!, $slug: String!) {
        updateOrganizationCountry(
          contacts: $contacts
          slug: $slug
        ) {
          organization {
            slug
            contacts {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'is successful' do
    contact2 = create(:contact, slug: 'c2', name: 'contact2', title: 'con2', email: null)
    contact1 = create(:contact, slug: 'c1', name: 'contact1', title: null, email: 'econ1')

    result = execute_graphql(
      mutation,
      variables: { contacts: [contact1, contact2], slug: 'o1' },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationCountry']['organization'])
        .to(eq({ "contacts" => [{ "slug" => "c1" }, { "slug" => "c2" }], "slug" => "o1" }))
    end
  end
end
