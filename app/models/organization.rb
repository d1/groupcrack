class Organization < ActiveRecord::Base
  attr_accessible :description, :name, :subdomain
  
  has_many :settings
end
