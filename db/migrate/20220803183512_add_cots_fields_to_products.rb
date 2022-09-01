# frozen_string_literal: true

class AddCotsFieldsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :commercial_product, :boolean, default: false)
    add_column(:products, :pricing_model, :string)
    add_column(:products, :pricing_details, :string)
    add_column(:products, :hosting_model, :string)
    add_column(:products, :pricing_date, :date)
    add_column(:products, :pricing_url, :string)
  end
end
