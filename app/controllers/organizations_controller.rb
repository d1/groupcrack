class OrganizationsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(params[:organization])

    if @organization.save
      OrganizationRole.create_org_roles(@organization)
      @organization.assign_admin(current_user)
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    # TODO this needs to be restricted to organization admins
    # look for a user_membership to org_role.is_admin
    # not sure that I want to allow an admin to change 
    # the subdomain of an org whenever they want
    # perhaps I need a subdomain history so people can find the org by the old subdomain too
    @organization = Organization.find(params[:id])
    
    if @organization.update_attributes(params[:organization])
      redirect_to @organization, notice: 'Organization was successfully updated.' 
    else
      render action: "edit"
    end
  end

  def destroy
    # TODO this needs to be restricted to admins
    @organization = Organization.find(params[:id])
    @organization.destroy
    
    redirect_to organizations_url
  end
end
