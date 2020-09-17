json.extract! building_block, :id, :name, :slug, :created_at, :updated_at
json.url building_block_url(building_block, format: :json)

json.building_block_descriptions building_block.building_block_descriptions do |bb_desc|
  json.extract! bb_desc, :description, :locale
end
