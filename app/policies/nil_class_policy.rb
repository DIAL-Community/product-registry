class NilClassPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def view_allowed?
    user.role == "admin"
  end

  def index?
    false
  end
end
