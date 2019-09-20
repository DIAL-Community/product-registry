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
end
