class AddDescriptionToMaturityRubricCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :rubric_category_descriptions do |t|
      t.references :rubric_category, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: {}
    end
  end
end
