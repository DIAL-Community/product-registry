json.extract! candidate_product, :id, :slug, :name, :website, :repository, :created_at, :updated_at
json.url candidate_product_url(candidate_product, format: :json)
