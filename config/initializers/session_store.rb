# frozen_string_literal: true

Rails.application.config.session_store(:redis_store, {
  servers: [
    { host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'],
      password: ENV['REDIS_PASSWORD'], db: 0 }
  ],
  key: '_session_store'
})
