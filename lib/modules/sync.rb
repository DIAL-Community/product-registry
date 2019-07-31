require 'modules/slugger'
include Modules::Slugger

module Modules
  module Sync
    def sync_unicef_product(json_data)

      if json_data['type'].detect{ |element| element.downcase == 'software' } != nil
        unicef_origin = Origin.find_by(:slug => 'unicef')
        name_aliases = [json_data['name'], json_data['initialism']].reject{ |x| x.nil? || x.empty? }

        existing_product = nil
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          existing_product = Product.find_by(name: name_alias)
          if existing_product.nil?
            existing_product = Product.find_by(":other_name = ANY(aliases)", other_name: name_alias)
          end
          if existing_product.nil?
            slug = slug_em name_alias
            existing_product = Product.find_by(slug: slug)
          end
        end

        if existing_product.nil?
          new_product = Product.new
          new_product.name = name_aliases.first
          new_product.slug = slug_em new_product.name
          new_product.website = json_data['website']
          new_product.aliases = name_aliases.reject{ |x| x == new_product.name }
          new_product.origins.push(unicef_origin)
          if new_product.save
            puts "New product added: #{new_product.name} -> #{new_product.slug}."
          end
        else
          existing_product.aliases.concat(name_aliases.reject{ |x| x == existing_product.name }).uniq!
          if (!existing_product.website.nil? && !existing_product.website.empty?)
            existing_product.website = json_data['website']
          end
          if (!existing_product.origins.exists?(:id => unicef_origin.id))
            existing_product.origins.push(unicef_origin)
          end
          if existing_product.save
            puts "Existing product updated: #{existing_product.name} -> #{existing_product.slug}."
          end
        end
      end
    end

    def sync_digisquare_product(section)

      slug_line = slug_em section['line']
      existing_product = Product.find_by(slug: slug_line)
      if existing_product.nil?
        existing_product = Product.find_by(":other_name = ANY(aliases)", other_name: section['line'])
      end

      if existing_product.nil?
        new_product = Product.new
        new_product.name = section['line']
        new_product.slug = slug_line
        new_product.origins.push(digisquare_origin)
        if new_product.save
          puts "Added new product: #{new_product.name} -> #{new_product.slug}."
        end
      else
        if (!existing_product.origins.exists?(id: digisquare_origin.id))
          existing_product.origins.push(digisquare_origin)
          existing_product.save
        end
        puts "Skipping existing product: #{existing_product.name}."
      end
    end

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

      osc_origin = Origin.find_by(:slug => 'dial_osc')
      if (!sync_product.origins.exists?(:id => osc_origin.id))
        sync_product.origins.push(osc_origin)
      end 

      sync_product.save
    end
  end
end
