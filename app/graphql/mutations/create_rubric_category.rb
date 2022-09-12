# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateRubricCategory < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :weight, Float, required: true
    argument :description, String, required: true

    field :rubric_category, Types::RubricCategoryType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, weight:, description:)
      unless an_admin
        return {
          rubric_category: nil,
          errors: ['Must be admin to create a rubric category']
        }
      end

      rubric_category = RubricCategory.find_by(slug: slug)

      if rubric_category.nil?
        rubric_category = RubricCategory.new(name: name)
        slug = slug_em(name)

        # Check if we need to add _dup to the slug.
        first_duplicate = RubricCategory.slug_simple_starts_with(slug_em(name))
                                        .order(slug: :desc).first
        if !first_duplicate.nil?
          rubric_category.slug = slug + generate_offset(first_duplicate)
        else
          rubric_category.slug = slug
        end
      end

      # allow user to rename rubric category but don't re-slug it
      rubric_category.name = name
      rubric_category.weight = weight

      if rubric_category.save
        rubric_category_desc = RubricCategoryDescription.find_by(rubric_category_id: rubric_category.id,
                                                                 locale: I18n.locale)
        rubric_category_desc = RubricCategoryDescription.new if rubric_category_desc.nil?
        rubric_category_desc.description = description
        rubric_category_desc.rubric_category_id = rubric_category.id
        rubric_category_desc.locale = I18n.locale
        rubric_category_desc.save

        # Successful creation, return the created object with no errors
        {
          rubric_category: rubric_category,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          rubric_category: nil,
          errors: rubric_category.errors.full_messages
        }
      end
    end
  end
end
