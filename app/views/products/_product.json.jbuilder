json.extract! product, :id, :name, :slug, :website, :product_versions, :created_at, :updated_at
json.url product_url(product, format: :json)
