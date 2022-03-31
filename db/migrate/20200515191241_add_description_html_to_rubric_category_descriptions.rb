# frozen_string_literal: true

class AddDescriptionHtmlToRubricCategoryDescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column(:rubric_category_descriptions, :description_html, :string)
  end
end
