# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'redis-rails'
gem 'simple_token_authentication', '~> 1.0'

gem 'actionpack-page_caching'
gem 'bootstrap'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'will_paginate'

gem 'sassc-rails'

gem 'google-api-client'
gem 'spreadsheet'

gem 'addressable'

gem 'pundit'

gem 'carrierwave'
gem 'mini_magick'
gem 'wysiwyg-rails'

gem 'http_accept_language'

gem 'cookies_eu'
gem 'Dhalang', github: 'conradsp/Dhalang', branch: 'master'
gem 'haml'

gem 'licensee'

gem 'kramdown', '~> 2.3.1'

gem 'recaptcha'

gem 'minitest-reporters'

gem 'rubysl-open3'

gem 'okcomputer'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'

gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.3.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rswag-api'
gem 'rswag-ui'

gem 'graphql'
gem 'rack-cors'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'combine_pdf'
gem 'pdfkit'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'teaspoon-mocha'

  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'

  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'poltergeist'

  gem 'rspec-rails'
  gem 'rswag-specs'

  gem 'rubocop'
  gem 'rubocop-graphql'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  # Seed data generator
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  gem 'listen', '>=3.0.5', '<4.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Auth/login/etc
gem 'devise'
gem 'jwt'

# Use Mailgun API to send confirmation emails
gem 'mailgun-ruby'

gem 'graphiql-rails', group: :development

# Throttling, blocking, etc.
gem 'rack-attack'

gem 'google-cloud-translate', '~> 3.2'

# Uploading images through GraphQL using v2 multi part request spec.
# https://github.com/jetruby/apollo_upload_server-ruby
gem 'apollo_upload_server', '2.1.0'
