class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_organization, :current_user_is_admin
  
  private
  
  def set_current_organization
    @current_organization = Organization.where(subdomain: request.subdomains.last).first
  end
  
  def validate_organization
    if @current_organization.nil?
      redirect_to welcome_path
    end
  end
  
  def current_user_is_admin
    @current_user_is_admin = false
    if current_user.present?
      if @current_organization.present?
        @current_user_is_admin = current_user.has_admin_role_at @current_organization
      else
        @current_user_is_admin = current_user.has_setting_value('site_administrator', 'yes')
      end
    end
  end
  
end
