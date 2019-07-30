class Product < ApplicationRecord
  has_one :product_assessment
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :sectors, join_table: :products_sectors
  has_and_belongs_to_many :sustainable_development_goals
  has_and_belongs_to_many :building_blocks, join_table: :products_building_blocks
  has_and_belongs_to_many :origins, join_table: :products_origins

  has_many :include_relationships, -> { where(relationship_type: 'composed')}, foreign_key: :from_product_id, class_name: 'ProductProductRelationship'
  has_many :includes, through: :include_relationships, source: :to_product

  has_many :interop_relationships, -> { where(relationship_type: 'interoperates')}, foreign_key: :from_product_id, class_name: 'ProductProductRelationship'
  has_many :interoperates_with, through: :interop_relationships, source: :to_product

  has_many :references, foreign_key: :to_product_id, class_name: 'ProductProductRelationship'

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(products.name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(products.slug) like LOWER(?)", "#{slug}%\\_")}

  def image_file
    if File.exist?(File.join('app','assets','images','products',"#{slug}.png"))
      return "products/#{slug}.png"
    else
      return "products/prod_placeholder.png"
    end
  end

  def to_param  # overridden
    slug
  end

  def maturity_scores
    @osc_maturity = YAML.load_file("config/maturity_osc.yml")
    @digisquare_maturity = YAML.load_file("config/maturity_digisquare.yml")

    toret = {}
    if !self.product_assessment.nil?
      if self.product_assessment.has_osc
        @osc_maturity.each do |osc_maturity_category|
          total_possible_score = 0
          total_score = 0
          osc_maturity_category['items'].each do |item|
            if self.product_assessment.send('osc_' + item["code"].downcase)
              total_score += 1
            end
          end
          toret[osc_maturity_category['header']] = {}
          toret[osc_maturity_category['header']]['total'] = osc_maturity_category['items'].length
          toret[osc_maturity_category['header']]['score'] = total_score
        end
      end
      if self.product_assessment.has_digisquare
        @digisquare_maturity.each do |digisquare_maturity_category|
          cat_total = 0
          digisquare_maturity_category["sub-indicators"].each do |sub_indicator|
            if self.product_assessment.send(sub_indicator['code'])
              cat_total += (self.product_assessment.send(sub_indicator['code']) - 2)
            end
          end
          cat_score = 5 * (cat_total.to_f / digisquare_maturity_category['sub-indicators'].length) + 5
          toret[digisquare_maturity_category['core']] = cat_score
        end
      end
    end
    toret
  end

end
