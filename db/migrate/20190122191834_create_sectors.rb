# frozen_string_literal: true

class CreateSectors < ActiveRecord::Migration[5.1]
  def change
    create_table(:sectors) do |t|
      t.string(:name)
      t.string(:slug)

      t.timestamps
    end
  end
end
