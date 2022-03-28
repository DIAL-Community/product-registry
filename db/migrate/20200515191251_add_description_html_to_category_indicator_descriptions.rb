# frozen_string_literal: true

class AddDescriptionHtmlToCategoryIndicatorDescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column(:category_indicator_descriptions, :description_html, :string)
  end
end
