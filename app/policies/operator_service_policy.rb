class OperatorServicePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.role == 'admin' || user.role == 'mni' 
  end

  def view_allowed?
    if user == nil
      return false
    end
    
    user.role == 'admin' || user.role == 'mni' 
  end
end
