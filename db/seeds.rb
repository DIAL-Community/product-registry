f = File.join(Rails.root, 'db', 'sustainable_development_goals.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'locations.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'sectors.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'organizations.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'contacts.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'building_blocks.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'products.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'sdg_targets.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'use_cases.rb')
if File.exists?(f)
  load f
end
f = File.join(Rails.root, 'db', 'workflows.rb')
if File.exists?(f)
  load f
end
