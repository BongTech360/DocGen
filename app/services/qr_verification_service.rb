class QrVerificationService
  def initialize(document)
    @document = document
  end

  def verify
    return { valid: false, message: 'Document not found' } unless @document
    
    if @document.verified?
      { valid: true, message: 'Document already verified', document: @document }
    elsif @document.status == 'generated'
      @document.update(status: 'verified')
      { valid: true, message: 'Document verified successfully', document: @document }
    else
      { valid: false, message: 'Document not ready for verification' }
    end
  end

  def verification_data
    {
      document_id: @document.id,
      title: @document.title,
      document_type: @document.document_type,
      organization: @document.organization.name,
      generated_at: @document.generated_at,
      status: @document.status,
      digital_stamp: @document.digital_stamp_data.present? ? JSON.parse(@document.digital_stamp_data) : nil
    }
  end
end

