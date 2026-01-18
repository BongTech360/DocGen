class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :documents, dependent: :destroy

  validates :name, presence: true
  validates :organization_type, presence: true, inclusion: { in: %w[visa_agency bank university] }
  validates :subdomain, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
end
