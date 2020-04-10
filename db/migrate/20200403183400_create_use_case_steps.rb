class CreateUseCaseSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :use_case_steps do |t|
      t.string :name
      t.string :slug
      t.integer :step_number
      t.references :use_case, foreign_key: true

      t.timestamps
    end
  end
end
