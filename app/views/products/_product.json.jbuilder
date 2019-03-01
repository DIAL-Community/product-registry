json.extract! product, :id, :name, :slug, :website, :created_at, :updated_at
json.url product_url(product, format: :json)
