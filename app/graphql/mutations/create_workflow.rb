# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateWorkflow < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: true
    argument :image_file, ApolloUploadServer::Upload, required: false

    field :workflow, Types::WorkflowType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:, image_file: nil)
      unless an_admin || a_content_editor
        return {
          workflow: nil,
          errors: ['Must be admin or content editor to create workflow']
        }
      end

      workflow = Workflow.find_by(slug: slug)

      if workflow.nil?
        workflow = Workflow.new(name: name)
        slug = slug_em(name)

        # Check if we need to add _dup to the slug.
        first_duplicate = Workflow.slug_simple_starts_with(slug).order(slug: :desc).first
        if !first_duplicate.nil?
          workflow.slug = slug + generate_offset(first_duplicate)
        else
          workflow.slug = slug
        end
      end

      # allow user to rename use case but don't re-slug it
      workflow.name = name

      if workflow.save
        unless image_file.nil?
          uploader = LogoUploader.new(workflow, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{workflow.name}. Standard error: #{e}."
          end
          workflow.auditable_image_changed(image_file.original_filename)
        end

        workflow_desc = WorkflowDescription.find_by(id: workflow.id, locale: I18n.locale)
        workflow_desc = WorkflowDescription.new if workflow_desc.nil?
        workflow_desc.description = description
        workflow_desc.workflow_id = workflow.id
        workflow_desc.locale = I18n.locale
        workflow_desc.save

        # Successful creation, return the created object with no errors
        {
          workflow: workflow,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          workflow: nil,
          errors: workflow.errors.full_messages
        }
      end
    end
  end
end
