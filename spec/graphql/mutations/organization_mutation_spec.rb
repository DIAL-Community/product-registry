# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateOrganization, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateOrganization(
        $name: String!,
        $slug: String!,
        $aliases: JSON,
        $website: String,
        $isEndorser: Boolean,
        $whenEndorsed: ISO8601Date,
        $endorserLevel: String,
        $isMni: Boolean
        ) {
        createOrganization(
          name: $name,
          slug: $slug,
          aliases: $aliases,
          website: $website,
          isEndorser: $isEndorser,
          whenEndorsed: $whenEndorsed,
          endorserLevel: $endorserLevel,
          isMni: $isMni
        ) {
            organization
            {
              name
            }
            error
          }
        }
      }
    GQL
  end

  it 'is successful' do
    create(:organization, name: 'Organization of Something', website: 'http://something.org')

    execute_graphql(
      mutation,
      variables: { name: 'Organization of Something' }
    )
  end

  it 'fails' do
    execute_graphql(
      mutation,
      variables: { name: 'Organization of Everything' }
    )
  end
end
