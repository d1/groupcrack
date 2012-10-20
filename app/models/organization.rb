class Organization < ActiveRecord::Base
  attr_accessible :description, :name, :subdomain
end
