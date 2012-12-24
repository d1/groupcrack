class SettingsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    obtain_settings

  end

  def show
  end

  def new
  end

  def create
  end

  def edit
    obtain_settings

    @current_setting = @settings_list.find_all{ |setting| setting[:setting_type_id] == params[:id].to_i}.first
    if @current_setting.present?
      @setting_type = SettingType.find(params[:id])
      @checked_value = @current_setting[:value_id]
    else
      flash[:notice] = "redirected from invalid form"
      redirect_to settings_path
    end
  end

  def update
    flash[:notice] = "update complete"
    redirect_to settings_path
  end

  def destroy
  end
  
  private
  
  def obtain_settings
    @current_user_is_admin = current_user.has_admin_role_at @current_organization
    
    if @current_user_is_admin
      @user = User.find params[:user_id] if params[:user_id].present?
    else
      # non admins should only see settings for themselves
      @user = current_user
    end
    
    @settings_list = Setting.list_settings(organization: @current_organization, user: @user, admin_right: @current_user_is_admin)
  end
end
