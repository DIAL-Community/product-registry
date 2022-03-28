# frozen_string_literal: true

Rails.application.config.content_security_policy do |policy|
  policy.frame_ancestors :self, 'toolkit-digitalisierung.de', 'govstack.global', 'www.govstack.global',
                         'govstack.wpengine.com', 'stagegovstack.wpengine.com'
end
