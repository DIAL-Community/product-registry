# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateProduct < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :aliases, GraphQL::Types::JSON, required: false
    argument :website, String, required: false
    argument :description, String, required: true
    argument :image_file, ApolloUploadServer::Upload, required: false

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, aliases: nil, website: nil, description:, image_file: nil)
      product = Product.find_by(slug: slug)

      unless an_admin || (a_product_owner(product.id) unless product.nil?)
        return {
          product: nil,
          errors: ['Must be admin or product owner to create an product']
        }
      end

      if product.nil?
        product = Product.new(name: name)
        product.slug = slug_em(name)

        if Product.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Product.where('LOWER(products.slug) like LOWER(?)', "#{slug_em(name)}%")
                                   .order(slug: :desc).first
          product.slug = product.slug + generate_offset(first_duplicate)
        end
      end

      product.aliases = aliases
      product.website = website

      if product.save
        unless image_file.nil?
          uploader = LogoUploader.new(product, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{product.name}. Standard error: #{e}."
          end
          product.auditable_image_changed(image_file.original_filename)
        end

        product_desc = ProductDescription.find_by(product_id: product.id, locale: I18n.locale)
        product_desc = ProductDescription.new if product_desc.nil?
        product_desc.description = description
        product_desc.product_id = product.id
        product_desc.locale = I18n.locale
        product_desc.save

        # Successful creation, return the created object with no errors
        {
          product: product,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          product: nil,
          errors: product.errors.full_messages
        }
      end
    end

    def generate_offset(first_duplicate)
      size = 0
      if !first_duplicate.nil? && first_duplicate.slug.include?('_dup')
        size = first_duplicate.slug
                              .slice(/_dup\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "_dup#{size}"
    end
  end
end
