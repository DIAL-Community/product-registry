json.extract! product, :id, :name, :slug, :website, :created_at, :updated_at
json.url product_url(product, format: :json)

json.product_descriptions product.product_descriptions do |prod_desc|
  json.extract! prod_desc, :description, :locale
end