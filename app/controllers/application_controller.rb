class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_organization
  
  private
  
  def set_current_organization
    @current_organization = Organization.where(subdomain: request.subdomains.last).first
  end
  
end
