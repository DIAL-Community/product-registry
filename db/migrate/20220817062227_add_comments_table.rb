# frozen_string_literal: true

class AddCommentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table(:comments) do |t|
      t.integer(:comment_object_id, null: false)
      t.jsonb(:author, null: false)
      t.string(:text, null: false)
      t.string(:comment_id, null: false)
      t.string(:parent_comment_id, null: true)

      t.timestamps
    end

    add_column(:comments, :comment_object_type, :comment_object_type, null: false)
  end
end
