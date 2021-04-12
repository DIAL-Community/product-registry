module Queries
  class CountriesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CountryType], null: false

    def resolve(search:)
      countries = Country.order(:name)
      unless search.blank?
        countries = countries.name_contains(search)
      end
      countries
    end
  end

  class SearchCountriesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    type Types::CountryType.connection_type, null: false

    def resolve(search:)
      countries = Country.order(:name)
      unless search.blank?
        countries = countries.name_contains(search)
      end
      countries
    end
  end
end
