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
