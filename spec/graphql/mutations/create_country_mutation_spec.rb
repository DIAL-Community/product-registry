# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateCountry, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateCountry(
        $name: String!
        $slug: String
        $code: String
        $codeLonger: String
      ) {
        createCountry(
          name: $name
          slug: $slug
          code: $code
          codeLonger: $codeLonger
        ) {
            country {
              name
              slug
              code
              codeLonger
            }
            errors
          }
        }
    GQL
  end

  let(:geocode_data) do
    <<~Geocode
      {
      	"results": [
      		{
      			"address_components": [
      				{
      					"long_name": "Kenya",
      					"short_name": "KE",
      					"types": [
      						"country",
      						"political"
      					]
      				}
      			],
      			"formatted_address": "Kenya",
      			"geometry": {
      				"location": {
      					"lat": -0.023559,
      					"lng": 37.906193
      				}
      			},
      			"types": [
      				"country",
      				"political"
      			]
      		}
      	],
      	"status": "OK"
      }
    Geocode
  end

  it 'is not successful - user is an admin but using random data' do
    expect_any_instance_of(Mutations::CreateCountry).to(receive(:an_admin).and_return(true))
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some Name",
        slug: "some_name",
        code: "Some Code",
        codeLonger: "Some Longer Code"
      }
    )

    aggregate_failures do
      expect(result['data']['createCountry']['country']).to(be(nil))
      expect(result['data']['createCountry']['errors'])
        .to(eq(['Unable to resolve known country data.']))
    end
  end

  it 'is successful - user is an admin and using valid data' do
    expect_any_instance_of(Mutations::CreateCountry).to(receive(:an_admin).and_return(true))
    expect_any_instance_of(Mutations::CreateCountry).to(receive(:geocode_with_google).and_return(geocode_data))
    result = execute_graphql(
      mutation,
      variables: {
        name: "Kenya"
      }
    )

    aggregate_failures do
      expect(result['data']['createCountry']['country'])
        .to(eq({ "name" => "Kenya", "slug" => "ke", "code" => "KE", "codeLonger" => "KEN" }))
    end
  end

  it 'is not successful - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some_name"
      }
    )

    aggregate_failures do
      expect(result['data']['createCountry']['country']).to(be(nil))
    end
  end
end
