class NilClassPolicy < ApplicationPolicy
  def view_allowed?
    false
  end
end