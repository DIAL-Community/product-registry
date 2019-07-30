require 'modules/slugger'
include Modules::Slugger

module Modules
  module Sync
    def sync_osc_product(product)
      puts "Syncing #{product['name']} ..."
      product_name = product['name']
      slug = slug_em product_name
      sync_product = Product.where('lower(name) = lower(?)', product_name)[0]
      if sync_product.nil?
        sync_product = Product.new
        sync_product.name = product_name
        sync_product.slug = slug
        if sync_product.save
          puts "  Added new product: #{sync_product.name} -> #{sync_product.slug}"
        end
      end

      website = product['website']
      if !website.nil? && !website.empty?
        puts "  Updating website: #{sync_product.website} => #{website}"
        sync_product.website = website
      end

      organizations = product['organizations']
      if !organizations.nil? && !organizations.empty?
        organizations.each do |organization|
          org = Organization.where('lower(name) = lower(?)', organization)[0]
          if !org.nil? && !sync_product.organizations.include?(org)
            puts "  Adding org to product: #{org.name}"
            sync_product.organizations << org
          end
        end
      end

      sdgs = product['SDGs']
      if !sdgs.nil? && !sdgs.empty?
        sdgs.each do |sdg|
          sdg_obj = SustainableDevelopmentGoal.where(number: sdg)[0]
          if !sdg_obj.nil? && !sync_product.sustainable_development_goals.include?(sdg_obj)
            puts "  Adding sdg #{sdg} to product"
            sync_product.sustainable_development_goals << sdg_obj
          end
        end
      end

      maturity = product['maturity']
      if !maturity.nil?
        product_assessment = sync_product.product_assessment
        if product_assessment.nil?
          puts "  Creating new maturity assessment"
          product_assessment = ProductAssessment.new
          product_assessment.product = sync_product
          product_assessment.save
        end
        product_assessment.has_osc = true
        maturity.each do |key, value|
          product_assessment["osc_#{key}"] = value
        end
        product_assessment.save
      end

      sync_product.save
    end
  end
end
