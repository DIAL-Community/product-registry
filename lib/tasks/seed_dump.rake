namespace :db do
  namespace :seed do
    task :dump => :environment do
      orgfile = File.open(File.join(Rails.root, 'db', 'seeds.rb'), "w")
      contactfile = File.open(File.join(Rails.root, 'db', 'contacts.rb'), "w")
      orgfile.puts "connection = ActiveRecord::Base.connection()"

      Sector.all.order('slug').each do |sector|
        # to_s isn't working right here
        disp = 'false'
        if sector.is_displayable
          disp = 'true'
        end
        orgfile.puts "Sector.create(name: \"#{sector.name}\", slug: '#{sector.slug}', is_displayable: #{disp}) if Sector.where(slug: '#{sector.slug}').empty?"
      end

      orgfile.puts "\n"

      Location.where(:location_type => :country).order('slug').each do |country|
        orgfile.puts "Location.create(name: \"#{country.name}\", slug: '#{country.slug}', :location_type => :country) if Location.where(slug: '#{country.slug}').empty?"
      end
      Location.where(:location_type => :point).order('slug').each do |office|
        orgfile.puts "Location.create(name: \"#{office.name}\", slug: '#{office.slug}', :location_type => :point) if Location.where(slug: '#{office.slug}').empty?"
        orgfile.puts "connection.execute(\"UPDATE locations SET points = ARRAY[ POINT (#{office.points[0][0]}, #{office.points[0][1]}) ] WHERE slug = '#{office.slug}'\")"
      end

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
      orgfile.puts "f = File.join(Rails.root, 'db', 'contacts.rb')"
      orgfile.puts "if File.exists?(f)"
      orgfile.puts "  load f"
      orgfile.puts "end"
    end
  end
end
