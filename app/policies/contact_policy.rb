class ContactPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.role == 'admin' || user.role == 'principle' || user.role == 'mni'
  end

  def view_allowed?
    user.role == 'admin' || user.role == 'principle' || user.role == 'mni'
  end
end
