# frozen_string_literal: true

class CreateDeploys < ActiveRecord::Migration[5.1]
  def change
    create_table :deploys do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.string :provider
      t.string :instance_name
      t.string :auth_token
      t.string :status
      t.string :message
      t.string :url
      t.string :suite
      t.integer :job_id

      t.timestamps
    end

    remove_column :products, :docker_image, :string
    add_column :products, :default_url, :string, null: false, default: 'http://<host_ip>'
  end
end
