class ActivityPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    !user.nil? && user.role == 'admin'
  end

  def view_allowed?
    true
  end
end
