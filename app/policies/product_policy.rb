class ProductPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    if mod_allowed?
      [:name, :is_launchable, :website, :slug, :aliases, :tags, :default_url, :logo, :start_assessment,
       :product_description]
    else
      []
    end
  end

  def create_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor])
  end

  def mod_allowed?
    return false if user.nil?

    if @record.is_a?(Product) && user.user_products.include?(@record.id) &&
       user.roles.include?(User.user_roles[:product_user])
      return true
    end

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def view_allowed?
    true
  end

  # Admin and content editor are allowed to remove product mapping.
  # Product owner is allowed if the product belongs to the owner.
  def removing_mapping_allowed?
    return false if user.nil?

    return true if user.roles.include?(User.user_roles[:product_user]) &&
      @record.is_a?(Product) && user.user_products.include?(@record.id)

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor])
  end

  # Admin, content editor and content writer are allowed to add product mapping.
  # Product owner is allowed if the product belongs to the owner.
  def adding_mapping_allowed?
    return false if user.nil?

    return true if user.roles.include?(User.user_roles[:product_user]) &&
      @record.is_a?(Product) && user.user_products.include?(@record.id)

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def beta_only?
    return true if user.nil?

    !user.roles.include?(User.user_roles[:content_editor]) &&
        !user.roles.include?(User.user_roles[:admin]) &&
        !user.roles.include?(User.user_roles[:ict4sdg])
  end
end
