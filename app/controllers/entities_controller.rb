# frozen_string_literal: true

class EntitiesController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:process_file]

  def process_file
    logger.info('Start of processing entity file ...')

    entity_uploader = EntityUploader.new(params[:entity_file].original_filename, current_user)
    begin
      entity_uploader.store!(params[:entity_file])
    rescue StandardError => e
      logger.error("Unable to save file. Message: #{e}.")
    end

    entity_uploader.retrieve_from_store!(entity_uploader.current_filename)
    json_data = JSON.parse(entity_uploader.file.read).with_indifferent_access
    if json_data.key('type')
      entity_object = generate_product(json_data)
      description_object = ProductDescription.new
    else
      entity_object = generate_project(json_data)
      description_object = ProjectDescription.new
    end

    captcha = params[:captcha]
    captcha_verified = Recaptcha.verify_via_api_call(captcha,
                                {
                                  secret_key: Rails.application.secrets.captcha_secret_key,
                                  skip_remote_ip: true
                                })

    respond_to do |format|
      if captcha_verified && entity_object.save
        # Save the description information.
        if json_data[:description]
          description_object.locale = I18n.locale
          description_object.description = json_data[:description]
          if json_data.key('type')
            description_object.product_id = entity_object.id
          else
            description_object.project_id = entity_object.id
          end
          description_object.save
        end

        format.json { render(json: { message: 'File processed.' }, status: :ok) }
      else
        format.json { render(json: { message: 'Unable to process file correctly.' }, status: :bad_request) }
      end
    end
  end

  def generate_product(json_data)
    slug = slug_em(json_data[:name])
    contacts = Product.where(slug: slug)
    unless contacts.empty?
      first_duplicate = Product.slug_starts_with(slug).order(slug: :desc).first
      slug += generate_offset(first_duplicate).to_s
    end

    origin = Origin.find_by(name: json_data[:origin])
    if origin.nil?
      origin = Origin.find_by(slug: json_data[:origin].downcase)
    end

    valid_aliases = []
    if json_data[:aliases] && !json_data[:aliases].empty?
      valid_aliases = json_data[:aliases].reject(&:empty?)
    end

    sectors = []
    unless json_data[:sectors].empty?
      json_data[:sectors].each do |sector_name|
        sector = Sector.find_by(name: sector_name)
        sectors << sector unless sector.nil?
      end
    end

    organizations = []
    if json_data[:organizations] && !json_data[:organizations].empty?
      json_data[:organizations].each do |organization_object|
        organization = Organization.find_by(name: organization_object.name)
        organizations << organization unless organization.nil?
      end
    end

    product_type = 'product'
    if json_data[:type] == 'data'
      product_type = 'dataset'
    elsif json_data[:type] == 'content'
      product_type = 'content'
    end

    Product.new(
      name: json_data[:name],
      aliases: valid_aliases,
      slug: slug,
      license: json_data[:license],
      origin: origin,
      sectors: sectors,
      organizations: organizations,
      repository_url: json_data[:repositoryURL],
      website: json_data[:website],
      product_type: product_type
    )
  end

  def generate_project(json_data)
    slug = slug_em(json_data[:name])
    contacts = Project.where(slug: slug)
    unless contacts.empty?
      first_duplicate = Project.slug_starts_with(slug).order(slug: :desc).first
      slug += generate_offset(first_duplicate).to_s
    end

    products = []
    if json_data[:products] && !json_data[:products].empty?
      json_data[:products].each do |product_name|
        product = Product.find_by(name: product_name)
        products << product unless product.nil?
      end
    end

    organizations = []
    if json_data[:organizations] && !json_data[:organizations].empty?
      json_data[:organizations].each do |organization_object|
        organization = Organization.find_by(name: organization_object.name)
        organizations << organization unless organization.nil?
      end
    end

    origin = Origin.find_by(name: json_data[:origin])
    if origin.nil?
      origin = Origin.find_by(slug: json_data[:origin].downcase)
    end

    countries = []
    unless json_data[:countries].empty?
      json_data[:countries].each do |country_name|
        country = Country.find_by(name: country_name)
        countries << country unless country.nil?
      end
    end

    sectors = []
    unless json_data[:sectors].empty?
      json_data[:sectors].each do |sector_name|
        sector = Sector.find_by(name: sector_name)
        sectors << sector unless sector.nil?
      end
    end

    Project.new(
      name: json_data[:name],
      slug: slug,
      start_date: Time.iso8601(json_data[:start_date]),
      end_date: Time.iso8601(json_data[:end_date]),
      project_url: json_data[:project_url],
      origin: origin,
      products: products,
      organizations: organizations,
      countries: countries,
      sectors: sectors
    )
  end
end
