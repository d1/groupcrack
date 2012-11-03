class Organization < ActiveRecord::Base
  attr_accessible :name, :subdomain, :description
  
  has_many :settings
  
  validates :name, :presence => true, :uniqueness => true
  validates :subdomain, :presence => true, :uniqueness => true
end
