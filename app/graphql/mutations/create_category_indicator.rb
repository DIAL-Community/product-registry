# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCategoryIndicator < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :indicator_type, String, required: false
    argument :weight, Float, required: true
    argument :rubric_category_slug, String, required: false
    argument :data_source, String, required: false
    argument :script_name, String, required: false
    argument :description, String, required: false

    field :category_indicator, Types::CategoryIndicatorType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, indicator_type: nil, rubric_category_slug: nil,
      weight:, data_source: nil, script_name: nil, description: nil)

      unless an_admin
        return {
          category_indicator: nil,
          errors: ['Must be admin to create a category indicator.']
        }
      end

      category_indicator = CategoryIndicator.find_by(slug: slug)

      if category_indicator.nil?
        category_indicator = CategoryIndicator.new(name: name)
        slug = slug_em(name)

        first_duplicate = CategoryIndicator.slug_simple_starts_with(slug_em(name))
                                           .order(slug: :desc).first
        if !first_duplicate.nil?
          category_indicator.slug = slug + generate_offset(first_duplicate)
        else
          category_indicator.slug = slug
        end
      end

      category_indicator.rubric_category_id = RubricCategory.find_by(slug: rubric_category_slug).id \
      unless rubric_category_slug.nil?

      # allow user to rename category indicator but don't re-slug it
      category_indicator.name = name
      category_indicator.weight = weight
      category_indicator.data_source = data_source
      category_indicator.script_name = script_name
      category_indicator.indicator_type = indicator_type

      if category_indicator.save
        category_indicator_description = CategoryIndicatorDescription
                                         .find_by(category_indicator_id: category_indicator.id, locale: I18n.locale)
        category_indicator_description = CategoryIndicatorDescription.new if category_indicator_description.nil?
        category_indicator_description.description = description
        category_indicator_description.category_indicator_id = category_indicator.id
        category_indicator_description.locale = I18n.locale
        category_indicator_description.save

        # Successful creation, return the created object with no errors
        {
          category_indicator: category_indicator,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          category_indicator: nil,
          errors: category_indicator.errors.full_messages
        }
      end
    end
  end
end
