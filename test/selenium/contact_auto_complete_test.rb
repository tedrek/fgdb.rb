require File.dirname(__FILE__) + '/../test_helper'

class NewTest < Test::Unit::SeleniumTestCase

  def test_contact_display
    set_speed "0"
    open "/"
    type "login", "admin"
    type "password", "secret"
    set_speed "4000"
    click "commit"
    click "link=donations"
    set_speed "13000"
    click "donation_contact_id"
    set_speed "0"
    type "donation_contact_id", "martin"
    key_press "donation_contact_id", " "
    assert !60.times{ break if (is_element_present("contact_edit_link") rescue false); sleep 1 }
    assert is_text_present("martin pamplemousse chase")
    click "donation_contact_id"
    type "donation_contact_id", "zzzzzz"
    set_speed "3000"
    key_press "donation_contact_id", "z"
    assert !is_text_present("martin")
  end
end
