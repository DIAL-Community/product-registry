require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Registry
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.i18n.available_locales = [:en, :es, :fr, :de]
    config.i18n.default_locale = :en
    config.i18n.locale = config.i18n.default_locale

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.geocode = config_for(:esri)
    config.settings = config_for(:settings)
  end
end
