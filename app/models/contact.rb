class Contact < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organizations_contacts

  validates :name,  presence: true, length: { maximum: 300 }
  validate :no_duplicates

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_contains, -> (slug) { where("LOWER(slug) like LOWER(?)", "%#{slug}%")}

  def can_be_saved?
    valid?
  end

  private

  def no_duplicates
    size = Contact.slug_contains(slug).size
    if size > 0
      errors.add(:duplicate, 'has duplicate.')
    end
  end

end
