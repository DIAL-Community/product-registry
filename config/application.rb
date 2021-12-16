require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Registry
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.i18n.available_locales = [:en, :cs, :fr, :de, :es, :pt, :sw]
    config.i18n.default_locale = :en
    config.i18n.locale = config.i18n.default_locale
    config.i18n.load_path += Dir[root.join('config', 'locales', '**', '*.yml')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.geocode = config_for(:esri)
    config.settings = config_for(:settings)

    config.exceptions_app = routes
  end
end
