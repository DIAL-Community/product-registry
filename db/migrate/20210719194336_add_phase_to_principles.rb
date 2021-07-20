class AddPhaseToPrinciples < ActiveRecord::Migration[5.2]
  def change
    add_column(:digital_principles, :phase, :string, :null => true)
  end
end
