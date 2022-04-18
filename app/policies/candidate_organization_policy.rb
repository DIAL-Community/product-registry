# frozen_string_literal: true

class CandidateOrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def create_allowed?
    return false if user.nil?

    true
  end

  def mod_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    return false if user.nil?

    true
  end
end
