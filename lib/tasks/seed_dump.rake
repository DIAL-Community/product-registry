namespace :db do
  namespace :seed do
    task :dump => :environment do
      building_block_file = File.open(File.join(Rails.root, 'db', 'building_blocks.rb'), 'w')
      BuildingBlock.all.order('slug').each do |bb|
        building_block_file.puts "BuildingBlock.create(name: \"#{bb.name}\", slug: '#{bb.slug}') if BuildingBlock.where(slug: '#{bb.slug}').empty?"
      end

      productfile = File.open(File.join(Rails.root, 'db', 'producs.rb'), 'w')
      Product.all.order('slug').each do |product|
        if product.building_blocks.empty?
          productfile.puts "Product.create(name: \"#{product.name}\", slug: '#{product.slug}') if Product.where(slug: '#{product.slug}').empty?"
        else
          productfile.puts "if Product.where(slug: '#{product.slug}').empty?"
          productfile.puts "  p = Product.create(name: \"#{product.name}\", slug: '#{product.slug}') if Product.where(slug: '#{product.slug}').empty?"
          product.building_blocks.each do |bb|
            productfile.puts "  p.building_blocks << BuildingBlock.where(slug: '#{bb.slug}').limit(1)[0]"
          end
          productfile.puts "end"
        end
      end

      sectorfile = File.open(File.join(Rails.root, 'db', 'sectors.rb'), "w")
      Sector.all.order('slug').each do |sector|
        # to_s isn't working right here
        disp = 'false'
        if sector.is_displayable
          disp = 'true'
        end
        sectorfile.puts "Sector.create(name: \"#{sector.name}\", slug: '#{sector.slug}', is_displayable: #{disp}) if Sector.where(slug: '#{sector.slug}').empty?"
      end

      locfile = File.open(File.join(Rails.root, 'db', 'locations.rb'), "w")
      locfile.puts "connection = ActiveRecord::Base.connection()"
      Location.where(:location_type => :country).order('slug').each do |country|
        locfile.puts "Location.create(name: \"#{country.name}\", slug: '#{country.slug}', :location_type => :country) if Location.where(slug: '#{country.slug}').empty?"
      end
      Location.where(:location_type => :point).order('slug').each do |office|
        locfile.puts "Location.create(name: \"#{office.name}\", slug: '#{office.slug}', :location_type => :point) if Location.where(slug: '#{office.slug}').empty?"
        locfile.puts "connection.execute(\"UPDATE locations SET points = ARRAY[ POINT (#{office.points[0][0]}, #{office.points[0][1]}) ] WHERE slug = '#{office.slug}'\")"
      end

      orgfile = File.open(File.join(Rails.root, 'db', 'organizations.rb'), "w")
      contactfile = File.open(File.join(Rails.root, 'db', 'contacts.rb'), "w")
      Organization.all.order('slug').each do |org|
        orgfile.puts "if Organization.where(slug: '#{org.slug}').empty?"
        d = org.when_endorsed
        orgfile.puts "  o = Organization.create(name: \"#{org.name}\", slug: '#{org.slug}', when_endorsed: DateTime.new(#{d.year}, #{d.month}, #{d.day}), is_endorser: true, website: \"#{org.website}\")"
        org.sectors.order('slug').each do |sector|
          orgfile.puts "  o.sectors << Sector.where(slug: '#{sector.slug}').limit(1)[0]"
        end
        org.locations.order('slug').each do |location|
          orgfile.puts "  o.locations << Location.where(slug: '#{location.slug}').limit(1)[0]"
        end
        org.contacts.each do |c|
          contactfile.puts "Organization.where(slug: '#{org.slug}').limit(1)[0].contacts << Contact.create(name: \"#{c.name}\", email: \"#{c.email}\", slug: '#{c.slug}') if Contact.where(slug: '#{c.slug}').empty?"
        end
        orgfile.puts "end"
      end

      seedfile = File.open(File.join(Rails.root, 'db', 'seeds.rb'), "w")
      ['locations', 'sectors', 'organizations', 'contacts', 'building_blocks', 'products'].each do |f|
        seedfile.puts "f = File.join(Rails.root, 'db', '#{f}.rb')"
        seedfile.puts "if File.exists?(f)"
        seedfile.puts "  load f"
        seedfile.puts "end"
      end
    end
  end
end
