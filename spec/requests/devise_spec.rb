require 'spec_helper'

describe 'UserRegistration' do
  it 'allows a user to register' do
    visit new_user_registration_path
    fill_in 'First name', :with => 'New'
    fill_in 'Last name', :with => 'User'
    fill_in 'Email', :with => 'newuser@example.com'
    fill_in 'user_password', :with => 'userpassword'
    fill_in 'user_password_confirmation', :with => 'userpassword'
    click_button 'Sign up'
    page.should have_content 'Welcome'
  end
end
