class UserEvent < ApplicationRecord
  enum event_type: {
    login_success: 'LOGIN SUCCESS', login_failed: 'LOGIN FAILED', index_view: 'INDEX VIEW',
    page_view: 'PAGE VIEW', product_view: 'PRODUCT VIEW'
  }
end
