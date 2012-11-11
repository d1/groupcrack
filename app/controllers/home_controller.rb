class HomeController < ApplicationController
  def index
    if @current_organization.nil?
      redirect_to welcome_path
    end
  end
  
  def about
  end
end
