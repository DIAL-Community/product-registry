class NilClassPolicy < ApplicationPolicy
  def view_allowed?
    false
  end

  def index?
    false
  end
end