class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.role == "admin"
  end

  def show?
    @current_user.role == "admin"
  end

  def edit?
    @current_user.role == "admin"
  end

  def update?
    @current_user.role == "admin"
  end

  def create?
    @current_user.role == "admin"
  end

  def new?
    @current_user.role == "admin"
  end

  def destroy?
    @current_user.role == "admin"
  end

  def mni?
    @current_user.role == "admin" || @current_user.role == "mni"
  end

  def principle?
    @current_user.role == "admin" || @current_user.role == "principle"
  end

  def ict4sdg?
    @current_user.role == "admin" || @current_user.role == "ict4sdg"
  end
end
