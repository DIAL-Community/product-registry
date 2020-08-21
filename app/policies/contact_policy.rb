class ContactPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) || user.roles.include?(User.user_roles[:principle]) || user.roles.include?(User.user_roles[:mni])
  end

  def view_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) || user.roles.include?(User.user_roles[:principle]) || user.roles.include?(User.user_roles[:mni])
  end
end
