require 'modules/slugger'
include Slugger

namespace :sync do
  desc "Sync the database with the digital public goods list."
  task :public_goods, [:path] => :environment do |task, params|
    Dir.entries(params[:path]).select{ |item| item.include? ".json" }.each do |entry|
      entry_data = File.read(File.join(params[:path], entry))

      begin
        json_data = JSON.parse(entry_data)
      rescue JSON::ParserError => e
        puts "Skipping unparseable json file: " + entry
        next
      end
      
      if (!json_data.key?("type") && !json_data.key?("name"))
        puts "Skipping unrecognized json file: " + entry
        next
      end

      if (json_data["type"].detect{ |element| element.downcase == "software" } != nil)
        new_product = Product.new
        existing_product = nil
        if !json_data["initialism"].nil?
          slug_initialism = Slugger::slug_em json_data["initialism"]
          existing_product = Product.where(slug: slug_initialism)[0]

          new_product.name = json_data["initialism"]
          new_product.slug = slug_initialism
        end

        if existing_product.nil?
          slug_name = Slugger::slug_em json_data["name"]
          existing_product = Product.where(slug: slug_name)[0]

          new_product.name = json_data["name"]
          new_product.slug = slug_name
        end

        if existing_product.nil?
          if new_product.save
            puts "Added new product: " + new_product.name + " -> " + new_product.slug
          end
        end
 
      end
    end
  end
end
