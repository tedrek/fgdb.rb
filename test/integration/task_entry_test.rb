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

  test "manipulating a volunteer task" do
    selector = '//tr[td[contains(., "4.0")]'\
               ' and td[contains(., "01/01/2000")]'\
               ' and td[contains(., "recycling (adoption)")]]'
    # Verify there isn't yet a matching task
    assert page.has_no_xpath?(selector)

    # Create a volunteer task
    visit '/volunteer_tasks'
    fill_in 'Search for a contact:', with: '3'
    fill_in 'what day?',           with: '2000-01-01'
    fill_in 'duration',            with: '4'
    select 'recycling (adoption)', from: 'Task type'
    select 'adoption',             from: 'Program'
    click_button  'Save Hours'
    assert page.has_xpath?(selector)

    # Edit the task
    page.find(:xpath, selector).click_link('Edit')
    sleep(2)
    assert_equal '4', page.find('#volunteer_task_duration').value
    fill_in 'duration', with: '5'
    click_button 'Save Hours'
    sleep(2)
    selector.sub!(/4\.0/, '5.0')
    assert page.has_xpath?(selector)

    # Destroy the task
    page.find(:xpath, selector).click_link('Destroy')
    assert page.has_no_xpath?(selector)
  end
end
