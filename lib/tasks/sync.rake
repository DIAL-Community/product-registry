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

      sync_unicef_product json_data

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
      # only process section 2 & 3 and the toc level 2
      # also skip the lorem ipsum
      if (!section['number'].start_with?("2", "3") ||
          section['toclevel'] != 2)
        next;
      end

      sync_digisquare_product section
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

  task :purge_removed_products, [:path] => :environment do |task, params|

    puts 'Pulling data from digital public good ...'

    unicef_origin = Origin.find_by(:slug => 'unicef')
    unicefList = []
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

      unicefList.push(json_data['name'])
      if json_data.key?('initialism')
        unicefList.push(json_data['initialism'])
      end
    end
    unicefProducts = Product.all.joins(:products_origins).where('origin_id=?', unicef_origin.id)
    unicefProducts.each do |product|
      if product.origins.count == 1
        # the product's only origin is Unicef
        if !unicefList.include?(product.name)
          # Send email to admin to remove this product
          msgString = "Product " + product.name + " is no longer in the Unicef list. Please remove from catalog"
          users = User.where(receive_backup: true)
          users.each do |user|
            cmd = "curl -s --user 'api:" + Rails.application.secrets.mailgun_api_key + "' https://api.mailgun.net/v3/"+Rails.application.secrets.mailgun_domain+"/messages -F from='Registry <backups@registry.dial.community>' -F to="+user.email+" -F subject='Sync task - delete product' -F text='"+msgString+"'"
            system cmd
          end
        end
      end
    end
  end

  task :update_version_data, [] => :environment do
    puts 'Starting to pull version data ...'

    Product.all.each do |product|
      sync_product_versions(product)
    end
  end

  task :update_license_data, [] => :environment do
    puts 'Starting to pull license data ...'

    Product.all.each do |product|
      sync_license_information(product)
    end
  end

  task :update_statistic_data, [] => :environment do
    puts 'Starting to pull statistic data ...'

    Product.all.each do |product|
      sync_product_statistics(product)
    end
  end
end
