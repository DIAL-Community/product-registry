require 'modules/slugger'

module Mutations
  class CreateCandidateProduct < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :website, String, required: true
    argument :repository, String, required: true
    argument :description, String, required: true
    argument :email, String, required: true
    argument :captcha, String, required: true

    field :slug, String, null: true

    def resolve(name:, website:, repository:, description:, email:, captcha:)
      candidate_product_params = {
        name: name,
        website: website,
        repository: repository,
        submitter_email: email,
        description: description
      }
      candidate_product_params[:slug] = slug_em(candidate_product_params[:name])

      candidate_products = CandidateProduct.where(slug: candidate_product_params[:slug])
      unless candidate_products.empty?
        first_duplicate = CandidateProduct.slug_starts_with(candidate_product_params[:slug])
                                          .order(slug: :desc).first
        candidate_product_params[:slug] = candidate_product_params[:slug] + generate_offset(first_duplicate).to_s
      end

      candidate_product = CandidateProduct.new(candidate_product_params)

      response = {}
      if Recaptcha.verify_via_api_call(captcha,
                                       {
                                         secret_key: Rails.application.secrets.captcha_secret_key,
                                         skip_remote_ip: true
                                       }) && candidate_product.save!
        response[:slug] = candidate_product.slug
      else
        response[:slug] = nil
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
end
