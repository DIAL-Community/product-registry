class DeployPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.role == 'admin' || user.role == 'principle' || user.role == 'ict4sdg'
  end

  def view_allowed?
    !user.nil? && user.role != 'user'
  end
end
