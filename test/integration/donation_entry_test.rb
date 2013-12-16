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
      assert page.has_content?('Hi! administrator'), "Logged in"
    end
  end

  test "entering donations" do
    visit '/donations'

    # Test the per donation type entries are working
    select 'named', from: 'What kind of contact?'
    # Something in capybara/poltergeist/phantomjs doesn't fire the
    # change event when using select()
    page.execute_script 'jQuery("#donation_contact_type").trigger("change");'
    assert page.has_content?('Search for a contact:')

    select 'anonymous', from: 'What kind of contact?'
    page.execute_script 'jQuery("#donation_contact_type").trigger("change");'
    assert page.has_content?('Postal code')

    select 'dumped', from: 'What kind of contact?'
    page.execute_script 'jQuery("#donation_contact_type").trigger("change");'
    assert page.has_no_content?('Postal code')
  end
end
