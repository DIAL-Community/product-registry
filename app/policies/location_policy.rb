class LocationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    if user.role == 'admin'
      [:id, :name, :confirmation, :aliases, :slug]
    end
  end

  def mod_allowed?
    user.role == "admin"
  end

  def view_allowed?
    true
  end
end
