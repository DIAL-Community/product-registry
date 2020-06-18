class AddMaturityScoreToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :maturity_score, :integer)
  end
end
