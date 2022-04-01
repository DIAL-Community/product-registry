# frozen_string_literal: true

module Queries
  class MovesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::MoveType], null: false

    def resolve(search:)
      moves = PlayMove.all.order(:name)
      unless search.blank?
        moves = moves.name_contains(search)
      end
      moves
    end
  end

  class MoveQuery < Queries::BaseQuery
    argument :play_slug, String, required: true
    argument :slug, String, required: true
    type Types::MoveType, null: false

    def resolve(play_slug:, slug:)
      play = Play.find_by(slug: play_slug)
      PlayMove.find_by(slug: slug, play_id: play.id)
    end
  end

  class SearchMovesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''

    type Types::MoveType.connection_type, null: false

    def resolve(search:, products:)
      moves = PlayMove.all.order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        moves = moves.name_contains(search)
      end

      filtered_products = products.reject { |x| x.nil? || x.empty? }
      unless filtered_products.empty?
        moves = moves.joins(:products)
                     .where(products: { id: filtered_products })
      end

      moves.distinct
    end
  end
end
