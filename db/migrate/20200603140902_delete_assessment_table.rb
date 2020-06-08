class DeleteAssessmentTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :product_assessments
  end
end
