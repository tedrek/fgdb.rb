require 'integration_test_helper'

class TaskEntryTest < ActionController::IntegrationTest
  fixtures :contacts, :users, :roles_users

  def setup
    Capybara.current_driver = :poltergeist
    Capybara.default_wait_time = 30
    visit '/'
    if !page.has_content?('Hi! administrator')
      fill_in 'login',    with: 'administrator'
      fill_in 'password', with: 'test'
      click_button 'Log in'
      assert page.has_content?('Hi! administrator'), "Login"
    end
  end

  test "creating a volunteer task" do
    visit '/volunteer_tasks'
    fill_in 'Search for a contact:', with: '3'
    fill_in 'what day?',           with: '2000-01-01'
    fill_in 'duration',            with: '4'
    select 'recycling (adoption)', from: 'Task type'
    select 'adoption',             from: 'Program'
    click_button  'Save Hours'
    assert page.has_xpath?('//tr[td[contains(., "4.0")]'\
                           ' and td[contains(., "01/01/2000")]'\
                           ' and td[contains(., "recycling (adoption)")]]')
  end
end
