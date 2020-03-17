# frozen_string_literal: true

if User.count == 0 && User.where(email: Rails.configuration.settings['admin_email']).count.zero?
  user = User.new email: Rails.configuration.settings['admin_email'],
                  password: 'admin-password',
                  password_confirmation: 'admin-password',
                  confirmed_at: Time.now.utc,
                  created_at: Time.now.utc,
                  updated_at: '1900-01-01',
                  role: 'admin'
  user.save validate: false
end

if Setting.where(slug: 'default_organization').count.zero?
  Setting.create! name: 'Default Organization',
                  slug: Rails.configuration.settings['install_org_key'],
                  description: 'The default installation organization who own the product (must use the slug value).',
                  value: 'digital_impact_alliance_dial'
end

if PortalView.where(slug: 'default').count.zero?
  PortalView.create! name: 'Default',
                  slug: 'default',
                  description: 'Default portal view',
                  top_navs: ['sdgs','use_cases','workflows','building_blocks','products','organizations'],
                  filter_navs:['sdgs','use_cases','workflows','building_blocks','products','organizations','locations','sectors'],
                  user_roles: ['admin','ict4sdg','principle','user','org_user','org_product_user','product_user','mni'],
                  product_views: ["DIAL OSC","Digital Square","Unicef","Digital Health Atlas"],
                  organization_views: ['endorser','mni','product']
end

if PortalView.where(slug: 'projects').count.zero?
  PortalView.create! name: 'Projects',
                  slug: 'projects',
                  description: 'Projects view',
                  top_navs: ['products','organizations', 'projects'],
                  filter_navs:['products','organizations','locations','projects'],
                  user_roles: ['admin','ict4sdg','principle','user','org_user','org_product_user','product_user','mni'],
                  product_views: ["DIAL OSC","Digital Square","Unicef","Digital Health Atlas"],
                  organization_views: ['endorser','mni','product']
end

if Stylesheet.where(portal: 'default').count.zero?
  Stylesheet.create! portal: 'default',
      background_color: '#000043'
end

if Stylesheet.where(portal: 'projects').count.zero?
  Stylesheet.create! portal: 'projects',
      background_color: '#430000'
end