class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    if user.role == 'admin' || user.role == 'principle' || user.role == 'mni'
      [:id, :name, :is_endorser, :is_mni, :when_endorsed, :website, :slug, :logo,
       :organization_description, :aliases]
    elsif user.role == 'org_user'
      [:name, :logo, :organization_description]
    else
      [:logo]
    end
  end

  def create_allowed?
    if (user.role == 'principle' || user.role == 'admin')
      return true
    end
    return false
  end

  def mod_allowed?
    if record.is_a?(Organization) && user.organization_id == record.id
      return true
    end

    if user.role == 'principle' && record.is_a?(Organization) && record.is_endorser
      return true
    end

    if user.role == 'mni' && record.is_a?(Organization) && record.is_mni
      return true
    end

    user.role == 'admin'
  end

  def view_capabilities_allowed?
    # DIAL is promoting the use of the catalog to help find aggregators, so we are adjusting the policy
    # to allow any user to see the services/capabilities offered.
    # If we want to go back to the original policy (only logged in users can view the capability), then 
    # remove the 'return true' line

    return true
    
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
