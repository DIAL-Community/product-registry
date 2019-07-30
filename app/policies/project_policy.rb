class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.role == "admin"
  end

  def view_allowed?
    user.role == "admin"
  end
end
