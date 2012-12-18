class SettingsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @current_user_is_admin = current_user.has_admin_role_at @current_organization
    
    if @current_user_is_admin
      @user = User.find params[:user_id] if params[:user_id].present?
    else
      # non admins should only see settings for themselves
      @user = current_user
    end
    
    @settings_list = Setting.list_settings(organization: @current_organization, user: @user, admin_right: @current_user_is_admin)
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
    @setting_type = SettingType.find(params[:id])
    # @checked_value = 2
  end

  def update
  end

  def destroy
  end
end
