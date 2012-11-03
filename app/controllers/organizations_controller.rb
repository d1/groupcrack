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
      # TODO make current_user an admin for the organization
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    # TODO this needs to be restricted to admins, 
    # not exactly sure that we want to allow an admin to change the subdomain of an org whenever tyhey want
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
