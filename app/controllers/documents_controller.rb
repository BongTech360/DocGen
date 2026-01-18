class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy, :generate_pdf, :verify]

  def index
    @documents = current_user.organization.documents.includes(:user).order(created_at: :desc)
    @documents = @documents.where(document_type: params[:type]) if params[:type].present?
  end

  def show
    @verification_service = QrVerificationService.new(@document)
  end

  def new
    @document = current_user.organization.documents.build
  end

  def create
    @document = current_user.organization.documents.build(document_params)
    @document.user = current_user
    @document.status = 'draft'
    
    # Parse JSON metadata if provided as string
    if params[:document][:metadata].is_a?(String) && params[:document][:metadata].present?
      begin
        @document.metadata = JSON.parse(params[:document][:metadata])
      rescue JSON::ParserError
        @document.errors.add(:metadata, "must be valid JSON")
        render :new, status: :unprocessable_entity and return
      end
    end

    if @document.save
      redirect_to @document, notice: 'Document was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    update_params = document_params
    
    # Parse JSON metadata if provided as string
    if params[:document][:metadata].is_a?(String) && params[:document][:metadata].present?
      begin
        update_params[:metadata] = JSON.parse(params[:document][:metadata])
      rescue JSON::ParserError
        @document.errors.add(:metadata, "must be valid JSON")
        render :edit, status: :unprocessable_entity and return
      end
    end
    
    if @document.update(update_params)
      redirect_to @document, notice: 'Document was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_url, notice: 'Document was successfully deleted.'
  end

  def generate_pdf
    service = DocumentGeneratorService.new(@document)
    pdf_data = service.generate

    send_data pdf_data,
      filename: "#{@document.title.parameterize}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def verify
    @verification_service = QrVerificationService.new(@document)
    
    if request.post?
      result = @verification_service.verify
      if result[:valid]
        redirect_to @document, notice: result[:message]
      else
        redirect_to verify_document_path(@document), alert: result[:message]
      end
    else
      @verification_data = @verification_service.verification_data
    end
  end

  def by_type
    @documents = current_user.organization.documents.where(document_type: params[:type])
    render :index
  end

  private

  def set_document
    @document = current_user.organization.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :document_type, :status, metadata: {})
  end
end
