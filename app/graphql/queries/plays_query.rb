# frozen_string_literal: true

module Queries
  class PlaysQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::PlayType], null: false

    def resolve(search:)
      plays = Play.all.order(:name)
      plays = plays.name_contains(search) unless search.blank?
      plays
    end
  end

  class PlayQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::PlayType, null: false

    def resolve(slug:)
      Play.find_by(slug: slug)
    end
  end

  class SearchPlaybookPlaysQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :slug, String, required: true

    type Types::PlayType.connection_type, null: false

    def resolve(slug:)
      Play.joins(:playbooks)
          .where(playbooks: { slug: slug })
          .order('playbook_plays.order')
    end
  end

  class SearchPlaysQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :products, [String], required: false, default_value: []

    type Types::PlayType.connection_type, null: false

    def resolve(search:, products:)
      plays = Play.all.order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        name_plays = plays.name_contains(search)
        desc_plays = plays.joins(:play_descriptions)
                          .where('LOWER(description) like LOWER(?)', "%#{search}%")
        plays = plays.where(id: (name_plays + desc_plays).uniq)
      end

      filtered_products = products.reject { |x| x.nil? || x.empty? }
      unless filtered_products.empty?
        plays = plays.joins(:products)
                     .where(products: { id: filtered_products })
      end

      plays.distinct
    end
  end
end
