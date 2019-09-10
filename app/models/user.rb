class User < ApplicationRecord
  enum role: { admin: 'admin', ict4sdg: 'ict4sdg', principle: 'principle', user: 'user', org_user: 'org_user' }
  after_initialize :set_default_role, if: :new_record?

  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  attr_accessor :is_approved

  validate :validate_organization

  def set_default_role
    self.role ||= :user
  end

  def validate_organization
    unless /\A[^@\s]+@digitalimpactalliance.org/.match?(email)
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
  end

  scope :email_contains, ->(email) { where('LOWER(email) like LOWER(?)', "%#{email}%")}

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
end
