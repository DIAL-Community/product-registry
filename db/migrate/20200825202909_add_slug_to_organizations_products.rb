# frozen_string_literal: true

class AddSlugToOrganizationsProducts < ActiveRecord::Migration[5.2]
  def up
    add_column(:organizations_products, :id, :primary_key)
    add_column(:organizations_products, :slug, :string)
    OrganizationsProduct.all.each do |op|
      op.slug = "#{op.organization.slug}_#{op.product.slug}"

      puts "Organization product updated with: #{op.slug}." if op.save!
    end
    change_column(:organizations_products, :slug, :string, null: false, unique: true)
  end

  def down
    remove_column(:organizations_products, :slug)
  end
end
