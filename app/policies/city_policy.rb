# frozen_string_literal: true

class CityPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def mod_allowed?
    !user.nil? && user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    true
  end
end
