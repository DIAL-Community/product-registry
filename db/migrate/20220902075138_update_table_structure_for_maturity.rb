# frozen_string_literal: true

class UpdateTableStructureForMaturity < ActiveRecord::Migration[5.2]
  def change
    drop_table(:maturity_rubrics, force: :cascade)
    drop_table(:maturity_rubric_descriptions, force: :cascade)
    remove_column(:rubric_categories, :maturity_rubric_id)
    add_column(:product_indicators, :updated_at, :datetime)
    add_column(:product_indicators, :script_name, :string)
  end
end
