class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.role == "admin" || user.role == "ict4sdg" || user.role == "user"
  end

  def view_allowed?
    true
  end
end
