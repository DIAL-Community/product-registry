# frozen_string_literal: true

json.array! @candidate_products, partial: 'candidate_products/candidate_product', as: :candidate_product
