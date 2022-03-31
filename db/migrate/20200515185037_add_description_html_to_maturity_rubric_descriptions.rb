# frozen_string_literal: true

class AddDescriptionHtmlToMaturityRubricDescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column(:maturity_rubric_descriptions, :description_html, :string)
  end
end
