# frozen_string_literal: true

class RemoveProductsTableColumns < ActiveRecord::Migration[5.2]
  def up
    remove_column(:products, :repository)

    remove_column(:products, :is_child)
    remove_column(:products, :parent_product_id)

    remove_column(:products, :publicgoods_data)
    remove_column(:products, :language_data)
    remove_column(:products, :statistics)

    remove_column(:products, :license_analysis)
    remove_column(:products, :license)

    remove_column(:products, :code_lines)
    remove_column(:products, :cocomo)
    remove_column(:products, :est_hosting)
    remove_column(:products, :est_invested)
  end

  def down
    add_column(:products, :repository, :string)

    add_column(:products, :is_child, :boolean, default: false)
    add_column(:products, :parent_product_id, :integer)

    add_column(:products, :publicgoods_data, :jsonb, null: false, default: {})
    add_column(:products, :language_data, :jsonb, null: false, default: {})
    add_column(:products, :statistics, :jsonb, null: false, default: '{}')

    add_column(:products, :license, :string)
    add_column(:products, :license_analysis, :string)

    add_column(:products, :code_lines, :integer)
    add_column(:products, :cocomo, :integer)
    add_column(:products, :est_hosting, :integer)
    add_column(:products, :est_invested, :integer)
  end
end
