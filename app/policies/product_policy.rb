class ProductPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    if user.role == 'admin' || user.role == 'principle'
      [:id, :name, :is_launchable, :website, :slug, :logo, :aliases]
    else
      [:logo]
    end
  end

  def mod_allowed?
    if record.is_a?(Product) && user.products.include?(record)
      return true
    end

    user.role == 'admin'
  end

  def view_allowed?
    true
  end
end
