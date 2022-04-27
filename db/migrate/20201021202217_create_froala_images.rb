# frozen_string_literal: true

class CreateFroalaImages < ActiveRecord::Migration[5.2]
  def change
    create_table(:froala_images) do |t|
      t.string(:picture)

      t.timestamps
    end
  end
end
