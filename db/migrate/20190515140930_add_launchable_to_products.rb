# frozen_string_literal: true

class AddLaunchableToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :is_launchable, :boolean, default: false
    add_column :products, :docker_image, :string
  end
end
