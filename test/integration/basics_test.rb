require 'integration_test_helper'

class BasicsTest < ActionController::IntegrationTest
  fixtures :users, :roles_users

  test "viewing the index page" do
    visit '/'
    assert page.has_content?('Welcome to the Free Geek Database')
  end

  test "viewing the index page with javascript" do
    Capybara.current_driver = :poltergeist
    visit '/'
    assert page.has_content?('Welcome to the Free Geek Database')
  end

  test "logging in as administrator" do
    Capybara.current_driver = :poltergeist
    visit '/'
    fill_in 'login',    with: 'administrator'
    fill_in 'password', with: 'test'
    click_button 'Log in'
    assert !page.has_content?('invalid username/password'),
           'check for invalid login credentials'
    assert page.has_content?('Hi! administrator'),
           'check correct user logged in'
  end
end
