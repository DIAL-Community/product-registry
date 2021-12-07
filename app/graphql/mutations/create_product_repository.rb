require 'modules/slugger'

module Mutations
  class CreateProductRepository < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :absolute_url, String, required: true
    argument :description, String, required: true
    argument :main_repository, Boolean, required: true

    field :slug, String, null: true

    def resolve(slug:, name:, absolute_url:, description:, main_repository:)
      repository_params = {
        name: name,
        absolute_url: absolute_url,
        description: description,
        main_repository: main_repository
      }
      repository_params[:slug] = slug_em(repository_params[:name])

      product_repositorys = ProductRepository.where(slug: repository_params[:slug])
      unless product_repositorys.empty?
        first_duplicate = ProductRepository.slug_starts_with(repository_params[:slug])
                                           .order(slug: :desc).first
        repository_params[:slug] = repository_params[:slug] + generate_offset(first_duplicate).to_s
      end

      response = { slug: nil }
      current_user = context[:current_user]
      current_product = Product.find_by(slug: slug)
      if (current_user.user_products.include?(current_product.id) &&
        current_user.roles.include?(User.user_roles[:product_user])) ||
        current_user.roles.include?(User.user_roles[:admin]) ||
        current_user.roles.include?(User.user_roles[:content_editor]) ||
        current_user.roles.include?(User.user_roles[:content_writer])

        repository_params[:updated_by] = current_user[:id]
        repository_params[:updated_at] = Time.now

        product_repository = ProductRepository.new(repository_params)
        product_repository.product = current_product

        if product_repository.save && product_repository.product.update({ manual_update: true })
          response[:slug] = product_repository.slug
        end
      end
      response
    end

    def generate_offset(first_duplicate)
      size = 1
      unless first_duplicate.nil?
        size = first_duplicate.slug
                              .slice(/_dup\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "_dup#{size}"
    end
  end

  class UpdateProductRepository < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :absolute_url, String, required: true
    argument :description, String, required: true
    argument :main_repository, Boolean, required: true

    field :slug, String, null: true

    def resolve(name:, slug:, absolute_url:, description:, main_repository:)
      repository_params = {
        name: name,
        absolute_url: absolute_url,
        description: description,
        main_repository: main_repository
      }

      response = { slug: nil }
      current_user = context[:current_user]
      product_repository = ProductRepository.find_by(slug: slug)
      if (current_user.user_products.include?(product_repository.product.id) &&
        current_user.roles.include?(User.user_roles[:product_user])) ||
        current_user.roles.include?(User.user_roles[:admin]) ||
        current_user.roles.include?(User.user_roles[:content_editor]) ||
        current_user.roles.include?(User.user_roles[:content_writer])

        repository_params[:updated_by] = current_user[:id]
        repository_params[:updated_at] = Time.now

        if product_repository.update!(repository_params) && product_repository.product.update!({ manual_update: true })
          response[:slug] = product_repository.slug
        end
      end
      response
    end
  end

  class DeleteProductRepository < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true

    field :slug, String, null: true

    def resolve(slug:)
      repository_params = {}

      response = { slug: nil }
      current_user = context[:current_user]
      product_repository = ProductRepository.find_by(slug: slug)
      if (current_user.user_products.include?(product_repository.product.id) &&
        current_user.roles.include?(User.user_roles[:product_user])) ||
        current_user.roles.include?(User.user_roles[:admin]) ||
        current_user.roles.include?(User.user_roles[:content_editor]) ||
        current_user.roles.include?(User.user_roles[:content_writer])

        repository_params[:deleted] = true
        repository_params[:deleted_by] = current_user.id
        repository_params[:deleted_at] = Time.now

        if product_repository.update!(repository_params)
          response[:slug] = product_repository.slug
        end
      end
      response
    end
  end
end
