# frozen_string_literal: true

class AddSavedUrlsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :saved_urls, :string, array: true, default: []
  end
end
