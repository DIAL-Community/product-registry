module Queries
  class CountriesQuery < Queries::BaseQuery

    type [Types::CountryType], null: false

    def resolve
      Country.all.order(:slug)
    end
  end
end