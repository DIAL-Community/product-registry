class AddSlugToOrganizationsContacts < ActiveRecord::Migration[5.2]
  def up
    add_column(:organizations_contacts, :slug, :string)
    OrganizationsContact.all.each do |oc|
      oc.slug = "#{oc.organization.slug}_#{oc.contact.slug}"

      if oc.save!
        puts "Organization contact updated with: #{oc.slug}."
      end
    end
    change_column(:organizations_contacts, :slug, :string, null: false, unique: true)
  end

  def down
    remove_column(:organizations_contacts, :slug)
  end
end
