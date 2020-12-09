class Origin < ApplicationRecord
  belongs_to :organization, optional: true
  has_and_belongs_to_many :products, join_table: :products_origins

  def self_url(options = {})
    return "#{options[:api_path]}/products?origins[]=#{slug}" if options[:api_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['self_url'] = self_url(options)
    json
  end
end
