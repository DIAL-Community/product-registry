module Queries
  class ProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ProductType], null: false

    def resolve(search:)
      products = Product.order(:name)
      unless search.blank?
        products = products.name_contains(search)
      end
      products
    end
  end

  class ProductQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ProductType, null: false

    def resolve(slug:)
      product = Product.find_by(slug: slug)
    end
  end

  class SearchProductsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :origins, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :workflows, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :product_types, [String], required: false, default_value: []

    type Types::ProductType.connection_type, null: false

    def resolve(search:, origins:, sectors:, countries:, organizations:, sdgs:, use_cases:, workflows:, building_blocks:, product_types:)
      products = Product.order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        products = products.name_contains(search)
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        products = products.joins(:origins)
                           .where(origins: { id: filtered_origins })
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        products = products.joins(:sectors)
                           .where(sectors: { id: filtered_sectors })
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        products = products.joins(:countries)
                           .where(countries: { id: filtered_countries })
      end

      filtered_organizations = organizations.reject { |x| x.nil? || x.empty? }
      unless filtered_organizations.empty?
        products = products.joins(:organizations)
                           .where(organizations: { id: filtered_organizations })
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        products = products.joins(:sustainable_development_goals)
                           .where(sustainable_development_goals: { id: filtered_sdgs })
      end
      products
    end
  end
end
