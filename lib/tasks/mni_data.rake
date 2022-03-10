require 'csv'

namespace :mni do
  desc 'Import MNI data into database.'
  task :import_csv  => :environment do
    mni_table = CSV.parse(File.read("./utils/MNIData.csv"), headers: true)
    puts "ROWS: " + mni_table.count.to_s
    aggregators=['9bitsng','Africas Talking','BetaSMS','Cellulant','ClickMobile','Comviva','engageSpark','IMImobile','InfoBip','MTECH','SynqAfrica','Viamo','Vodacom','Mobile Accord Inc','Axieva']
    aggregator_ids = { }
    # Create the aggregator organizations if they don't exist
    aggregators.each do |aggregator|
      new_agg = Organization.where(name: aggregator).first
      if new_agg == nil
        new_agg = Organization.new
        new_agg.name = aggregator
        new_agg.slug = slug_em(aggregator)
        new_agg.is_mni = true
        new_agg.is_endorser = false
        new_agg.save
      end
      aggregator_ids[aggregator] = new_agg.id
    end
    mni_table.each do |mni_row|
      # Check to see if the operator location services exists
      if (mni_row['Country'] != nil) && (mni_row['Core Service'] != nil) && (mni_row['Operator'] != nil)
        country_name = mni_row['Country'].strip
        core_service = mni_row['Core Service'].strip
        operator = mni_row['Operator'].strip
        country = Country.where(name: country_name).first
        #if location == nil
          # Create the country record
        #  puts "Adding Country: " + country_name
        #  location = Location.new
        #  location.name = country_name
        #  location.location_type = 'country'
        #  location.slug = slug_em(country_name)
        #  location.save
        #end
        operator_service = OperatorService.where(name: operator, country_id: country.id, service: core_service).first
        if operator_service == nil
          #puts "Adding operator service: " + mni_row['Operator'] +","+location.id.to_s+","+mni_row['Core Service']
          operator_service = OperatorService.new
          operator_service.name = operator
          operator_service.country_id = country.id
          operator_service.service = core_service
          operator_service.save
        end
        # now add the aggregator data
        capability = mni_row['Service Type'].strip
        aggregators.each do |aggregator|
          begin
            if mni_row[aggregator] == 'y'
              agg_capability = AggregatorCapability.new
              agg_capability.aggregator_id = aggregator_ids[aggregator]
              agg_capability.operator_services_id = operator_service.id
              agg_capability.service = core_service
              agg_capability.capability = capability
              agg_capability.country_name = country_name
              agg_capability.save
            end
            next
          rescue
            next
          end
        end
      end
    end
  end
  task :create_aggregators  => :environment do
    aggregators=['9bitsng','Africas Talking','BetaSMS','Cellulant','ClickMobile','Comviva','engageSpark','IMImobile','InfoBip','MTECH','SynqAfrica','Viamo','Vodacom','Mobile Accord Inc','Axieva']
    aggregator_ids = { }
    # Create the aggregator organizations if they don't exist
    aggregators.each do |aggregator|
      new_agg = Organization.where(name: aggregator).first
      if new_agg == nil
        new_agg = Organization.new
        new_agg.name = aggregator
        new_agg.slug = slug_em(aggregator)
        new_agg.is_mni = true
        new_agg.is_endorser = false
        new_agg.save
      else 
        new_agg.is_mni = true
        new_agg.save
      end
      # Add countries based on aggregator_capabilities
      country_list = AggregatorCapability.select(:country_name).where(aggregator_id: new_agg.id).map(&:country_name).uniq
      country_list.each do |country_name|
        currCountry = Location.where(name: country_name).first
        currLoc = new_agg.locations.where(id: currCountry.id).first
        if currLoc == nil
          new_agg.locations.push(currCountry)
        end
      end
      new_agg.save
    end
  end
  task :export_csv  => :environment do
    @operator_services = OperatorService.all
    @aggregator_capabilities = AggregatorCapability.all
    File.write("operator_services.csv", @operator_services.to_csv)
    File.write("aggregator_capability.csv", @aggregator_capabilities.to_csv)
  end
end
