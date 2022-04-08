# frozen_string_literal: true

class AddAuthorToPlaybooks < ActiveRecord::Migration[5.2]
  def change
    add_column :playbooks, :author, :string
  end
end
