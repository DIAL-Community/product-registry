class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.role == "admin" || user.role == "principle"
  end

  def export_contacts_allowed?
    user.role == "admin" || user.role == "principle"
  end

  def view_allowed?
    true
  end
end
