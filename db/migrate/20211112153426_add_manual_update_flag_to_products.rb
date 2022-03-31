# frozen_string_literal: true

class AddManualUpdateFlagToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :manual_update, :boolean, default: false)
  end
end
