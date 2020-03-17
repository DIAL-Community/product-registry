class SettingPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    user.role == 'admin'
  end

  def view_allowed?
    user.role == 'admin'
  end

  def permitted_attributes
    if user.role == 'admin'
      [:name, :description, :value]
    else
      []
    end
  end
end
