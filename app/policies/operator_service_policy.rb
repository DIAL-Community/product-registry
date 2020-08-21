class OperatorServicePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.roles.include?(User.user_roles[:admin]) || user.roles.include?(User.user_roles[:mni]) 
  end

  def view_allowed?
    if user == nil
      return false
    end
    
    user.roles.include?(User.user_roles[:admin]) || user.roles.include?(User.user_roles[:mni]) 
  end

  def map_allowed?
    return true
  end
end
