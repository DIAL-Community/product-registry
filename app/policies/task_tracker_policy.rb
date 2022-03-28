# frozen_string_literal: true

class TaskTrackerPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def mod_allowed?
    !user.nil? && user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    !user.nil? && user.roles.include?(User.user_roles[:admin])
  end
end
