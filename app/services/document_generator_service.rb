class DocumentGeneratorService
  require 'prawn'
  require 'prawn/qrcode'
  require 'rqrcode'
  require 'digest'

  def initialize(document)
    @document = document
  end

  def generate
    pdf = Prawn::Document.new(page_size: 'A4', margin: [50, 50, 50, 50])
    
    # Add header
    pdf.text @document.title, size: 24, style: :bold, align: :center
    pdf.move_down 20

    # Add document type specific content
    case @document.document_type
    when 'visa'
      generate_visa_document(pdf)
    when 'bank_document'
      generate_bank_document(pdf)
    when 'agreement'
      generate_agreement_document(pdf)
    when 'invoice'
      generate_invoice_document(pdf)
    end

    # Add digital stamp
    add_digital_stamp(pdf)

    # Add QR code for verification
    add_qr_code(pdf)

    # Add footer
    pdf.number_pages "Page <page> of <total>", {
      at: [pdf.bounds.right - 150, 0],
      width: 150,
      align: :right,
      size: 10
    }

    pdf_data = pdf.render
    @document.update(
      generated_at: Time.current,
      status: 'generated',
      qr_code_data: @document.generate_qr_code
    )

    pdf_data
  end

  private

  def generate_visa_document(pdf)
    metadata = @document.metadata || {}
    
    pdf.text "VISA DOCUMENT", size: 18, style: :bold
    pdf.move_down 15
    
    pdf.text "Passport Number: #{metadata['passport_number']}", size: 12
    pdf.text "Visa Type: #{metadata['visa_type']}", size: 12
    pdf.text "Country: #{metadata['country']}", size: 12
    pdf.text "Issue Date: #{metadata['issue_date']}", size: 12
    pdf.text "Expiry Date: #{metadata['expiry_date']}", size: 12
    pdf.text "Duration: #{metadata['duration']}", size: 12
    
    if metadata['holder_name']
      pdf.move_down 10
      pdf.text "Holder: #{metadata['holder_name']}", size: 12, style: :bold
    end
  end

  def generate_bank_document(pdf)
    metadata = @document.metadata || {}
    
    pdf.text "BANK DOCUMENT", size: 18, style: :bold
    pdf.move_down 15
    
    pdf.text "Account Number: #{metadata['account_number']}", size: 12
    pdf.text "Transaction ID: #{metadata['transaction_id']}", size: 12
    pdf.text "Amount: #{metadata['amount']}", size: 12
    pdf.text "Currency: #{metadata['currency']}", size: 12
    pdf.text "Date: #{metadata['date']}", size: 12
    pdf.text "Description: #{metadata['description']}", size: 12
    
    if metadata['balance']
      pdf.move_down 10
      pdf.text "Balance: #{metadata['balance']}", size: 12, style: :bold
    end
  end

  def generate_agreement_document(pdf)
    metadata = @document.metadata || {}
    
    pdf.text "AGREEMENT", size: 18, style: :bold
    pdf.move_down 15
    
    pdf.text "Parties:", size: 14, style: :bold
    pdf.text "Party 1: #{metadata['party1']}", size: 12
    pdf.text "Party 2: #{metadata['party2']}", size: 12
    pdf.move_down 10
    
    pdf.text "Effective Date: #{metadata['effective_date']}", size: 12
    pdf.text "Expiry Date: #{metadata['expiry_date']}", size: 12
    pdf.move_down 10
    
    pdf.text "Terms and Conditions:", size: 14, style: :bold
    pdf.text metadata['terms'] || 'Terms and conditions apply.', size: 12
  end

  def generate_invoice_document(pdf)
    metadata = @document.metadata || {}
    
    pdf.text "INVOICE", size: 18, style: :bold
    pdf.move_down 15
    
    pdf.text "Invoice Number: #{metadata['invoice_number']}", size: 12
    pdf.text "Date: #{metadata['date']}", size: 12
    pdf.text "Bill To: #{metadata['bill_to']}", size: 12
    pdf.move_down 10
    
    pdf.text "Items:", size: 14, style: :bold
    if metadata['items'].is_a?(Array)
      metadata['items'].each do |item|
        pdf.text "#{item['description']} - #{item['quantity']} x #{item['price']} = #{item['total']}", size: 12
      end
    end
    pdf.move_down 10
    
    pdf.text "Subtotal: #{metadata['subtotal']}", size: 12
    pdf.text "Tax: #{metadata['tax']}", size: 12
    pdf.text "Total: #{metadata['total']}", size: 14, style: :bold
  end

  def add_digital_stamp(pdf)
    # Add digital stamp at the bottom
    pdf.move_down 30
    pdf.stroke_color "000000"
    pdf.stroke_rectangle [0, pdf.cursor], pdf.bounds.width, 60
    
    pdf.move_down 10
    pdf.text "Digitally Stamped", size: 10, align: :center
    pdf.text "Organization: #{@document.organization.name}", size: 10, align: :center
    pdf.text "Date: #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}", size: 10, align: :center
    pdf.text "Document ID: #{@document.id}", size: 10, align: :center
    
    # Store stamp data
    stamp_data = {
      organization: @document.organization.name,
      timestamp: Time.current.iso8601,
      document_id: @document.id,
      hash: Digest::SHA256.hexdigest("#{@document.id}#{Time.current.iso8601}")
    }
    @document.update(digital_stamp_data: stamp_data.to_json)
  end

  def add_qr_code(pdf)
    # Generate QR code
    qr_data = @document.generate_qr_code
    qrcode = RQRCode::QRCode.new(qr_data)
    
    # Add QR code to PDF
    pdf.move_down 20
    pdf.render_qr_code(qrcode, pos: [pdf.bounds.width - 100, pdf.cursor], extent: 80)
    
    pdf.move_down 90
    pdf.text "Scan QR code to verify document", size: 8, align: :right
  end
end

