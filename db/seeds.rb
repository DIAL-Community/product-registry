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
