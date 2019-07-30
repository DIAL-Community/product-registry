require 'modules/slugger'
require 'modules/sync'
include Modules::Slugger
include Modules::Sync

namespace :sync do
  desc 'Sync the database with the public goods lists.'
  task :public_goods, [:path] => :environment do |task, params|

    puts 'Pulling data from digital public good ...'

    Dir.entries(params[:path]).select{ |item| item.include? '.json' }.each do |entry|
      entry_data = File.read(File.join(params[:path], entry))

      begin
        json_data = JSON.parse(entry_data)
      rescue JSON::ParserError
        puts "Skipping unparseable json file: #{entry}"
        next
      end

      if !json_data.key?('type') && !json_data.key?('name')
        puts "Skipping unrecognized json file: #{entry}"
        next
      end

      if json_data['type'].detect{ |element| element.downcase == 'software' } != nil
        unicef_origin = Origin.find_by(:slug => 'unicef')
        aliases = Array.new
        new_product = Product.new
        existing_product = nil
        unless json_data['initialism'].nil?
          slug_initialism = slug_em json_data['initialism']
          existing_product = Product.find_by(slug: slug_initialism)

          if existing_product.nil?
            existing_product = Product.find_by(":other_name = ANY(aliases)", other_name: json_data['initialism'])
          end

          aliases.push(json_data['name'])
          new_product.name = json_data['initialism']
          new_product.slug = slug_initialism
        end

        if existing_product.nil?
          slug_name = slug_em json_data['name']
          existing_product = Product.find_by(slug: slug_name)

          if existing_product.nil?
            existing_product = Product.find_by(":other_name = ANY(aliases)", other_name: json_data['name'])
          end

          aliases.push(json_data['initialism'])
          new_product.name = json_data['name']
          new_product.slug = slug_name
        end

        if existing_product.nil?
          new_product.aliases = aliases.reject{ |x| x.nil? || x.empty? || x == new_product.name }
          new_product.origins.push(unicef_origin)
          if new_product.save
            puts "Added new product: #{new_product.name} -> #{new_product.slug}."
          end
        else
          puts "Skipping existing product: #{existing_product.name}."
          if (!existing_product.origins.exists?(:id => unicef_origin.id))
            existing_product.origins.push(unicef_origin)
            existing_product.save
          end
        end

      end
    end
    puts 'Digital public good data synced ...'
  end

  task :digi_square_digital_good, [:path] => :environment do |task, params|
    puts "Pulling data from digital square ..."

    digi_square_location = "https://wiki.digitalsquare.io/api.php?"\
                      "action=parse&format=json&prop=sections&"\
                      "page=Digital_Square_Investments_in_Global_Goods:Approved_Global_Goods"
    digi_square_uri = URI.parse(digi_square_location)
    digi_square_response = Net::HTTP.get(digi_square_uri)
    digi_square_data = JSON.parse(digi_square_response)

    digi_square_data['parse']['sections'].each do |section|
      digisquare_origin = Origin.find_by(:slug => 'digital_square')
      # only process section 2 & 3 and the toc level 2
      # also skip the lorem ipsum
      if (!section['number'].start_with?("2", "3") ||
          section['toclevel'] != 2 ||
          section['line'].start_with?("Lorem"))
        next;
      end

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

    puts "Digital square data synced ..."

  end

  task :osc_digital_good, [:path] => :environment do |task, params|
    puts "Starting pulling data from open source center ..."

    osc_location = "https://www.osc.dial.community/digital_global_goods.json"
    osc_uri = URI.parse(osc_location)
    osc_response = Net::HTTP.get(osc_uri)
    osc_data = JSON.parse(osc_response)
    osc_data.each do |product|
      sync_osc_product product
    end
  end
end
