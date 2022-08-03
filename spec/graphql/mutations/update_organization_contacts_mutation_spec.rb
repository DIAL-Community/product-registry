# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationContacts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($contacts: JSON!, $slug: String!) {
        updateOrganizationContacts(
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
    first = create(:contact, name: 'First Person', slug: 'first_person')
    second = create(:contact, name: 'Second Person', slug: 'second_person')

    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')

    expect_any_instance_of(Mutations::UpdateOrganizationContacts).to(receive(:an_admin).and_return(true))
    result = execute_graphql(
      mutation,
      variables: { contacts: [first, second], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationContacts']['organization'])
        .to(eq({ "contacts" => [{ "slug" => first.slug }, { "slug" => second.slug }], "slug" => organization.slug }))
    end
  end

  # TODO: Probably going to need to add more spec here.
  # * Test for organization owner.
  # * Test for unathorized users trying to do graph modification.
end
