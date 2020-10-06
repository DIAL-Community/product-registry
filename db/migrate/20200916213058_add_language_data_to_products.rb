class AddLanguageDataToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :language_data, :jsonb, null: false, default: {})
  end
end
