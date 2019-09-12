class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    if user.role == 'admin' || user.role == 'principle'
      [:id, :name, :is_endorser, :when_endorsed, :website, :slug, :logo]
    else
      [:logo]
    end
  end

  def mod_allowed?
    if record.is_a?(Organization) && user.organization_id == record.id
      return true
    end

    user.role == 'admin' || user.role == 'principle'
  end

  def export_contacts_allowed?
    user.role == 'admin' || user.role == 'principle'
  end

  def view_allowed?
    true
  end
end
