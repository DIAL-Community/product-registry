class User < ApplicationRecord
  enum role: { admin: 'admin', ict4sdg: 'ict4sdg', principle: 'principle', user: 'user', org_user: 'org_user' }
  after_initialize :set_default_role, if: :new_record?

  has_and_belongs_to_many :products, join_table: :users_products

  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  # Custom function validation
  validate :validate_product, :validate_organization

  attr_accessor :is_approved

  def set_default_role
    self.role ||= :user
  end

  def validate_organization
    # Skip organization validation when the email is DIAL email.
    return if /\A[^@\s]+@digitalimpactalliance.org/.match?(email)

    # Skip organization validation when the user is signing up to be product owner.
    return unless products.empty?

    if organization_id.nil?
      logger.info 'User need to select organization to register without DIAL email.'
      errors.add(:organization_id, I18n.translate('view.devise.organization-required'))
    else
      organization = Organization.find(organization_id)
      email_domain = /\A[^@\s]+@([^@\s]+\z)/.match(email)[1]
      logger.info "Matching organization website: '#{organization.website}' with '#{email_domain}'."
      verified = organization.website.include?(email_domain)
      verified && self.role = User.roles[:org_user]
      !verified && errors.add(:organization_id, I18n.translate('view.devise.organization-nomatch'))
    end
  end

  def validate_product
    return if products.empty?

    skip_confirmation_notification!
  end

  scope :email_contains, ->(email) { where('LOWER(email) like LOWER(?)', "%#{email}%")}

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
end
