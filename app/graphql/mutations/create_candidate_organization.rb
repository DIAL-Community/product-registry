require 'modules/slugger'

module Mutations
  class CreateCandidateOrganization < Mutations::BaseMutation
    include Modules::Slugger

    argument :organization_name, String, required: true
    argument :website, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true
    argument :email, String, required: true
    argument :title, String, required: true
    argument :captcha, String, required: true

    field :slug, String, null: true

    def resolve(organization_name:, website:, description:, name:, email:, title:, captcha:)
      candidate_params = { name: organization_name, website: website, description: description }
      candidate_params[:slug] = slug_em(candidate_params[:name])

      candidate_organizations = CandidateOrganization.where(slug: candidate_params[:slug])
      unless candidate_organizations.empty?
        first_duplicate = CandidateOrganization.slug_starts_with(candidate_params[:slug])
                                               .order(slug: :desc).first
        candidate_params[:slug] = candidate_params[:slug] + generate_offset(first_duplicate).to_s
      end

      candidate_organization = CandidateOrganization.new(candidate_params)

      unless name.blank?
        contact_params = { name: name, email: email, title: title }
        contact_params[:slug] = slug_em(contact_params[:name])

        contacts = Contact.where(slug: contact_params[:slug])
        unless contacts.empty?
          first_duplicate = Contact.slug_starts_with(contact_params[:slug]).order(slug: :desc).first
          contact[:slug] = contact[:slug] + generate_offset(first_duplicate).to_s
        end
        candidate_organization.contacts << Contact.new(contact_params)
      end

      response = {}
      if Recaptcha.verify_via_api_call(captcha,
                                       {
                                         secret_key: Rails.application.secrets.captcha_secret_key,
                                         skip_remote_ip: true
                                       }) && candidate_organization.save!
        response[:slug] = candidate_organization.slug
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
