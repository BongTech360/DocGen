class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :edit, :update]
  before_action :ensure_admin, only: [:new, :create, :edit, :update]

  def index
    if current_user.organization.present?
      redirect_to current_user.organization
    else
      @organizations = Organization.all
    end
  end

  def show
    @users = @organization.users
    @documents = @organization.documents.order(created_at: :desc).limit(10)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      current_user.update(organization: @organization) if current_user.organization.nil?
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_organization
    @organization = current_user.organization || Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :organization_type, :subdomain)
  end

  def ensure_admin
    # In a real application, you'd check for admin role
    # For now, allow any authenticated user to create organizations
    redirect_to root_path, alert: 'Access denied.' unless user_signed_in?
  end
end
