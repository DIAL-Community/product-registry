class AddTagsToUseCases < ActiveRecord::Migration[5.1]
  def change
    add_column :use_cases, :tags, :string, array: true, default: []
  end
end
