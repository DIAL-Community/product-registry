class PlaybookPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    !user.nil? && (user.roles.include?(User.user_roles[:admin]) || user.roles.include?(User.user_roles[:content_editor]))
  end

  def view_allowed?
    true
  end
end
