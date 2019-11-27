class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    if user.role == 'admin' || user.role == 'principle' || user.role == 'mni'
      [:id, :name, :is_endorser, :is_mni, :when_endorsed, :website, :slug, :logo]
    elsif user.role == 'org_user'
      [:name, :logo]
    else
      [:logo]
    end
  end

  def mod_allowed?
    if record.is_a?(Organization) && user.organization_id == record.id
      return true
    end

    if user.role == 'principle'
      return true
    end

    if user.role == 'mni' && record.is_a?(Organization) && record.is_mni
      return true
    end

    user.role == 'admin'
  end

  def view_capabilities_allowed?
    if !user
      return false
    end

    if (user.role == 'mni' || user.role == 'admin')
      return true
    end

    if user.organization_id == record.id
      return true
    end
  
    # get the org for the user 
    userOrg = Organization.where(:id => user.organization_id).first
    puts "ORG: " + userOrg[:is_mni].to_s
    if userOrg[:is_mni]
      return false
    else
      return true
    end
  end

  def export_contacts_allowed?
    user.role == 'admin' || user.role == 'principle' || user.role == 'mni'
  end

  def view_allowed?
    true
  end
end
