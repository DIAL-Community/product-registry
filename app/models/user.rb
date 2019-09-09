class User < ApplicationRecord
  enum role: { admin: 'admin', ict4sdg: 'ict4sdg', principle: 'principle', user: 'user', org_user: 'org_user' }
  after_initialize :set_default_role, if: :new_record?

  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  attr_accessor :is_approved

  def set_default_role
    self.role ||= :user
  end

  scope :email_contains, ->(email) { where('LOWER(email) like LOWER(?)', "%#{email}%")}

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
end
