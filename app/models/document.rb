class Document < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :document_type, presence: true, inclusion: { in: %w[visa bank_document agreement invoice] }
  validates :status, presence: true, inclusion: { in: %w[draft generated signed verified] }
  validates :title, presence: true

  # Store document-specific data in JSONB metadata field
  # For visas: passport_number, visa_type, country, dates, etc.
  # For bank documents: account_number, transaction_id, amount, etc.
  # For agreements: parties, terms, dates, etc.
  # For invoices: invoice_number, items, total, tax, etc.

  scope :visas, -> { where(document_type: 'visa') }
  scope :bank_documents, -> { where(document_type: 'bank_document') }
  scope :agreements, -> { where(document_type: 'agreement') }
  scope :invoices, -> { where(document_type: 'invoice') }

  def generate_qr_code
    # Generate QR code data for verification
    # In production, use actual domain
    base_url = Rails.env.production? ? "https://#{organization.subdomain}.docgen.com" : "http://localhost:3000"
    "#{base_url}/documents/#{id}/verify"
  end

  def verified?
    status == 'verified'
  end
end
