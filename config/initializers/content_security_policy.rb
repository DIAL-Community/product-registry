Rails.application.config.content_security_policy do |policy|
  policy.frame_ancestors :self, 'toolkit-digitalisierung.de', 'govstack.global','www.govstack.global','govstack.wpengine.com','govstack-website.blee.ch'
end