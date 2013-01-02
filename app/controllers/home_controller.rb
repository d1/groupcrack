class HomeController < ApplicationController
  
  before_filter :validate_organization
  
  def index
  end
  
  def about
  end
end
