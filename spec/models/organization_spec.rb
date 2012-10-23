require 'spec_helper'

describe Organization do
  
  before do
    @organization = Organization.new(name: "Sample Group", subdomain: "sample", description: "Sample Description")
  end
  
  subject { @organization }
  
  it { should respond_to :name }
  it { should respond_to :subdomain }
  it { should respond_to :description }
  
  # describe "Organization creation process" do 
  #   
  # end
  
end
