namespace :data do
  desc 'Data related rake tasks.'
  task :clean_website  => :environment do
    Organization.all.each do |organization|
      previous_website = organization.website
      organization.website = organization.website
                                         .strip
                                         .sub(/^https?\:\/\//i,'')
                                         .sub(/^https?\/\/\:/i,'')
                                         .sub(/\/$/, '')
      if (organization.save)
        puts "Website changed: #{previous_website} -> #{organization.website}"
      end
    end
  end
end
