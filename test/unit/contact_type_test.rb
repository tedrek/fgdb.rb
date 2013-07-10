require File.dirname(__FILE__) + '/../test_helper'

class ContactTypeTest < ActiveSupport::TestCase

  load_all_fixtures()

  NEW_CONTACT_TYPE = {}    # e.g. {:name => 'Test ContactType', :description => 'Dummy'}
  REQ_ATTR_NAMES              = %w( ) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = contact_types(:first)
  end

  def test_raw_validation
    contact_type = ContactType.new
    if REQ_ATTR_NAMES.blank?
      assert contact_type.valid?, "ContactType should be valid without initialisation parameters"
    else
      # If ContactType has validation, then use the following:
      assert !contact_type.valid?, "ContactType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert contact_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_new
    contact_type = ContactType.new(NEW_CONTACT_TYPE)
    assert contact_type.valid?, "ContactType should be valid"
    NEW_CONTACT_TYPE.each do |attr_name|
      assert_equal NEW_CONTACT_TYPE[attr_name], contact_type.attributes[attr_name], "ContactType.@#{attr_name.to_s} incorrect"
    end
  end

  def test_validates_presence_of
    REQ_ATTR_NAMES.each do |attr_name|
      tmp_contact_type = NEW_CONTACT_TYPE.clone
      tmp_contact_type.delete attr_name.to_sym
      contact_type = ContactType.new(tmp_contact_type)
      assert !contact_type.valid?, "ContactType should be invalid, as @#{attr_name} is invalid"
      assert contact_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_duplicate
    current_contact_type = ContactType.find(:first)
    DUPLICATE_ATTR_NAMES.each do |attr_name|
      contact_type = ContactType.new(NEW_CONTACT_TYPE.merge(attr_name.to_sym => current_contact_type[attr_name]))
      assert !contact_type.valid?, "ContactType should be invalid, as @#{attr_name} is a duplicate"
      assert contact_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_automatic_type_assignment
    pairs = {:sale => 'buyer', :donation => 'donor', :build => 'build', :adoption => 'adopter'}
    pairs.each {|name, type|
      blank = empty_contact
      assert blank.contact_types.empty?
      retval = nil
      case name
      when :sale
        sale = Sale.new({ :contact => blank, :contact_type => 'named',
                          :payments => [paid_a_dollar],
                          :created_by => 1,
                          :discount_name => DiscountName.find(:first),
                          :discount_percentage => DiscountPercentage.find(:first, :conditions => "percentage = 0"),
                          :gizmo_events => [a_mouse_for_sale]})
        assert sale.valid?, "#{name} is valid (Errors: #{sale.errors})"
        assert_nothing_raised {retval = sale.save}
        assert retval, "#{name} should have saved successfully"
      when :donation
        don = Donation.new({ :contact => blank, :contact_type => 'named',
                             :created_by => 1,
                             :payments => [paid_a_dollar]})
        assert_nothing_raised {retval = don.save}
        assert retval
      when :build
        v_t = an_hour_of_assembly
        v_t.contact = blank
        assert_nothing_raised {retval = v_t.save}
        assert retval
      when :adoption
        v_t = an_hour_of_monitors
        v_t.contact = blank
        assert_nothing_raised {retval = v_t.save}
        assert retval
      end
      assert ! blank.contact_types.empty?, "contact_types should not be empty after #{name} is saved"
      assert blank.contact_types.detect {|c_t| c_t.description == type}, "Contact should be of type '#{type}'"
    }
  end

  def empty_contact
    c = Contact.new({:first_name=>"Joe", :middle_name=>'', :surname=> 'Strummer',
    :organization=>'', :extra_address=>'', :address=>'Elsewhere',
    :city=>'London', :state_or_province=>'UK', :postal_code=>'123',
    :country=>'Britain', :notes=>'', :created_by=>1})
    c.save!
    c
  end

  def paid_a_dollar
    Payment.new({:payment_method => PaymentMethod.cash, :amount => "1.0"})
  end

  def a_mouse_for_sale
    GizmoEvent.new({ :gizmo_count => 1, :gizmo_type => GizmoType.find(23),
                     :gizmo_context => GizmoContext.sale, :unit_price => "1.0", :as_is => false})
  end
end

