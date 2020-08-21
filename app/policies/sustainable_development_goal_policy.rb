class SustainableDevelopmentGoalPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.roles.include?(User.user_roles[:admin]) || user.roles.include?(User.user_roles[:ict4sdg])
  end

  def view_allowed?
    true
  end
end
