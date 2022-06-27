# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateProject < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :start_date, GraphQL::Types::ISO8601Date, required: false
    argument :end_date, GraphQL::Types::ISO8601Date, required: false
    argument :project_url, String, required: false
    argument :description, String, required: true
    argument :product_id, Integer, required: false
    argument :organization_id, Integer, required: false

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, start_date: nil, end_date: nil, project_url: nil, description:,
      product_id: nil, organization_id: nil)
      project = Project.find_by(slug: slug)

      check = false
      if project.nil?
        check = an_admin || (a_product_owner(product_id) unless product_id.nil?) ||
                (an_org_owner(organization_id) unless organization_id.nil?)
      else
        check = an_admin || product_owner_check_for_project(project) || org_owner_check_for_project(project)
      end

      unless check
        return {
          project: nil,
          errors: ['Must be admin, product owner or organization owner to create a project']
        }
      end

      if project.nil?
        project = Project.new(name: name)
        project.slug = slug_em(name)

        if Project.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Project.where('LOWER(projects.slug) like LOWER(?)', "#{slug_em(name)}%")
                                   .order(slug: :desc).first
          project.slug = project.slug + generate_offset(first_duplicate)
        end
      end

      # allow user to rename project but don't re-slug it
      project.name = name
      project.start_date = start_date unless start_date.nil?
      project.end_date = end_date unless end_date.nil?
      project.project_url = project_url unless project_url.nil?

      # Defaulting to manually entered
      project.origin = Origin.find_by(slug: 'manually_entered') if project.origin.nil?

      unless product_id.nil?
        product = Product.find_by(id: product_id)
        project.products << product unless product.nil?
      end

      unless organization_id.nil?
        organization = Organization.find_by(id: organization_id)
        project.organizations << organization unless organization.nil?
      end

      if project.save
        project_desc = ProjectDescription.find_by(project_id: project.id, locale: I18n.locale)
        project_desc = ProjectDescription.new if project_desc.nil?
        project_desc.description = description
        project_desc.project_id = project.id
        project_desc.locale = I18n.locale
        project_desc.save

        # Successful creation, return the created object with no errors
        {
          project: project,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          project: nil,
          errors: project.errors.full_messages
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
