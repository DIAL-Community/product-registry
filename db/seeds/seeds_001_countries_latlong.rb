# frozen_string_literal: true

country_togo = Country.find_by(slug: 'togo')
unless country_togo.nil?
  country_togo.code = 'TG'
  country_togo.slug = 'tg'
  country_togo.latitude = 8.619543
  country_togo.longitude = 0.824782

  if country_togo.save!
    puts "#{country_togo.name} data saved!"
  end
end

country_invalid_georgia = Country.find_by(name: 'Georgia', slug: 'ga')
country_valid_georgia = Country.find_by(name: 'Georgia', slug: 'ge')
unless country_invalid_georgia.nil?
  projects_with_valid_georgia = Project.joins(:countries).where(countries: { slug: 'ge', name: 'Georgia' })
  puts "Project with invalid georgia: #{projects_with_valid_georgia.count}."

  projects_with_valid_georgia.each do |project|
    countries = project.countries.reject { |country| country.slug == 'ge' }
    countries << country_invalid_georgia
    project.countries = countries

    if project.save!
      puts "Country data for project: '#{project.name}' updated."
    end
  end

  organizations_with_valid_georgia = Organization.joins(:countries).where(countries: { slug: 'ge', name: 'Georgia' })
  puts "Organization with invalid georgia: #{organizations_with_valid_georgia.count}."

  organizations_with_valid_georgia.each do |organization|
    countries = organization.countries.reject { |country| country.slug == 'ge' }
    countries << country_invalid_georgia
    organization.countries = organization

    if organization.save!
      puts "Country data for organization: '#{organization.name}' updated."
    end
  end

  regions_with_valid_georgia = Region.where(country_id: country_valid_georgia.id)
  puts "Regions with invalid georgia: #{regions_with_valid_georgia.count}."

  regions_with_valid_georgia.each do |region|
    region.country_id = country_invalid_georgia.id
    if region.save!
      puts "Region data for region: '#{region.name}' updated."
    end
  end

  if Country.find_by(name: 'Georgia', slug: 'ge').destroy
    puts "Deleting correct Georgia data and recreating them after this."
  end

  country_invalid_georgia.code = 'GE'
  country_invalid_georgia.slug = 'ge'
  country_invalid_georgia.latitude = 42.315407
  country_invalid_georgia.longitude = 43.356892

  if country_invalid_georgia.save!
    puts "#{country_invalid_georgia.name} data saved!"
  end
end
