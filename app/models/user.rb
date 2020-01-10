class User < ApplicationRecord
  enum role: { admin: 'admin', ict4sdg: 'ict4sdg', principle: 'principle',
               user: 'user', org_user: 'org_user', org_product_user: 'org_product_user',
               product_user: 'product_user', mni: 'mni' }
  after_initialize :set_default_role, if: :new_record?

  has_and_belongs_to_many :products, join_table: :users_products

  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :update, if: :password_changed?

  # Custom function validation
  validate :validate_organization, :validate_product

  attr_accessor :is_approved

  def set_default_role
    self.role ||= :user
  end

  def after_database_authentication
    if expired && reset_password_token.nil?
      self.expired = false
      self.expired_at = nil
      save(validate: false)
    end
  end

  def password_expire?
    logger.info('Checking if user record is expired!')
    return true if expired && !reset_password_token.nil?
    return true if email == Rails.configuration.settings['admin_email'] && updated_at.nil?

    today = Date.today
    !confirmed_at.nil? && !updated_at.nil? && updated_at + 90 < today
  end

  def generate_reset_token
    # Implementation from recoverable.rb -> set_reset_password_token.
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

    current_time = Time.now.utc
    self.reset_password_token   = enc
    self.reset_password_sent_at = current_time
    self.expired                = true
    self.expired_at             = current_time
    save(validate: false)
    raw
  end

  def password_changed?
    !password.blank?
  end

  def validate_organization
    # Skip validation for already created user, only for new user.
    return if persisted?

    # Skip organization validation for default admin username.
    return if email == Rails.configuration.settings['admin_email']

    # Find the default organization and allow installation organization to register
    # with their email address.
    organization_setting = Setting.find_by(slug: Rails.configuration.settings['install_org_key'])
    if organization_setting
      installation_organization = Organization.find_by(slug: organization_setting.value)
      if installation_organization && email.end_with?(installation_organization.website)
        self.organization_id = installation_organization.id
        return
      end
    end

    if organization_id.nil?
      # Skip organization validation when the user is signing up to be product owner.
      return unless products.empty?

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
    # Skip validation for already created user, only for new user.
    return if persisted?

    return if products.empty?

    organization_id.nil? && self.role = User.roles[:product_user]
    !organization_id.nil? && self.role = User.roles[:org_product_user]
    skip_confirmation_notification!
  end

  scope :email_contains, ->(email) { where('LOWER(email) like LOWER(?)', "%#{email}%")}

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
end
