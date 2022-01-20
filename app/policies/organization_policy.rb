class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    return [] if user.nil?

    if user.roles.include?(User.user_roles[:admin]) ||
         user.roles.include?(User.user_roles[:principle]) ||
         user.roles.include?(User.user_roles[:mni])
      [:id, :name, :is_endorser, :is_mni, :when_endorsed, :endorser_level, :website, :slug, :logo,
       :organization_description, :aliases]
    elsif user.roles.include?(User.user_roles[:org_user]) &&
          @record.is_a?(Organization) && user.organization_id == @record.id
      [:name, :logo, :organization_description]
    else
      [:logo]
    end
  end

  def create_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:principle]) ||
      user.roles.include?(User.user_roles[:admin])
  end

  def mod_allowed?
    return false if user.nil?

    return true if user.roles.include?(User.user_roles[:org_user]) &&
        @record.is_a?(Organization) && user.organization_id == @record.id

    return true if user.roles.include?(User.user_roles[:principle]) &&
        @record.is_a?(Organization) && @record.is_endorser

    return true if user.roles.include?(User.user_roles[:mni]) &&
        @record.is_a?(Organization) && @record.is_mni

    user.roles.include?(User.user_roles[:admin])
  end

  def view_capabilities_allowed?
    # DIAL is promoting the use of the catalog to help find aggregators, so we are adjusting the policy
    # to allow any user to see the services/capabilities offered.
    # If we want to go back to the original policy (only logged in users can view the capability), then
    # remove the 'true' line

    true

    # return false if user.nil?

    # return true if user.roles.include?(User.user_roles[:mni]) ||
    #     user.roles.include?(User.user_roles[:admin])

    # return true if user.roles.include?(User.user_roles[:org_user]) &&
    #     @record.is_a?(Organization) && user.organization_id == @record.id

    # # get the org for the user
    # user_org = Organization.where(id: user.organization_id).first
    # user_org[:is_mni]
  end

  def export_contacts_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:principle]) ||
      user.roles.include?(User.user_roles[:mni])
  end

  def view_allowed?
    true
  end

  # Admin and content editor are allowed to remove product mapping.
  # Product owner is allowed if the product belongs to the owner.
  def removing_mapping_allowed?
    return false if user.nil?

    return true if user.roles.include?(User.user_roles[:org_user]) &&
      @record.is_a?(Organization) && user.organization_id == @record.id

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor])
  end

  # Admin, content editor and content writer are allowed to add product mapping.
  # Product owner is allowed if the product belongs to the owner.
  def adding_mapping_allowed?
    return false if user.nil?

    return true if user.roles.include?(User.user_roles[:org_user]) &&
      @record.is_a?(Organization) && user.organization_id == @record.id

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end
end
