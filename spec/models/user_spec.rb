require 'spec_helper'

describe User do
  
  before do
    @user = User.new(first_name: "Firstname", last_name: "Lastname", email: "user@example.com",  password: "test123")
  end
  
  subject { @user }
  
  it { should respond_to :name }
  it { should be_valid }
  
end
