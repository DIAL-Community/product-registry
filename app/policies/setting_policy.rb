class SettingPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    !user.nil? && user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    !user.nil? && user.roles.include?(User.user_roles[:admin])
  end

  def permitted_attributes
    if user.roles.include?(User.user_roles[:admin])
      [:name, :description, :value]
    else
      []
    end
  end
end
