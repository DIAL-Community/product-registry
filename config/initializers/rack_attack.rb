# frozen_string_literal: true

catalog_ux_routes = [
  '/authenticate/credentials',
  '/authenticate/signup',
  '/authenticate/signup',
  '/auth/reset-password',
  '/auth/apply-reset-token',
  '/auth/validate-reset-token',
  '/graphql'
]

# Rack::Attack.throttle('Catalog UX routes.', limit: 10, period: 1.minute) do |request|
#  request.ip if catalog_ux_routes.any? { |route| request.path.include?(route) } && request.post?
# end

# Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

# Rack::Attack.blocklisted_response = lambda do |_request|
# Using 503 because it may make attacker think that they have successfully
# DOSed the site. Rack::Attack returns 403 for blocklists by default
#  [503, {}, ['Server Error.']]
# end

# Rack::Attack.throttled_response = lambda do |_request|
# NB: you have access to the name and other data about the matched throttle
#  request.env['rack.attack.matched'],
#  request.env['rack.attack.match_type'],
#  request.env['rack.attack.match_data'],
#  request.env['rack.attack.match_discriminator']

# Using 503 because it may make attacker think that they have successfully
# DOSed the site. Rack::Attack returns 429 for throttling by default
#  [503, {}, ["Server Error."]]
# end
