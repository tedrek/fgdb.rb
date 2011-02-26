class SpecSheet < ActiveRecord::Base
  include SystemHelper

  validates_presence_of :contact_id
  validates_presence_of :action_id
  validates_presence_of :type_id

  belongs_to :contact
  belongs_to :action
  belongs_to :system
  belongs_to :type
  has_one :contract, :through => :system

  validates_existence_of :type
  validates_existence_of :action
  validates_existence_of :contact

  named_scope :good, :conditions => ["cleaned_valid = ? AND original_valid = ?", true, true]
  named_scope :bad, :conditions => ["cleaned_valid = ? AND original_valid = ?", false, false]
  named_scope :originally_bad, :conditions => ["cleaned_valid = ? AND original_valid = ?", true, false]
  named_scope :clean_broke_it, :conditions => ["cleaned_valid = ? AND original_valid = ?", false, true]

  before_save :set_contract_id_and_covered
  def contract_id
    @contract_id ||= (system ? system.contract_id : nil)
  end

  def signed_off_by
    self.cashier_signed_off_by.nil? ? "Not signed off." : User.find(self.cashier_signed_off_by).contact.display_name
  end

  def signed_off_by=(user)
    new = user.id
    self.cashier_signed_off_by = (self.cashier_signed_off_by == new ? nil : new)
  end

  def contract_id=(val)
    @contract_id = val
  end

  def covered
    @covered ||= (system ? system.covered : nil)
  end

  def covered=(val)
    @covered = val
  end

  def set_contract_id_and_covered
    if system
      if !(@contract_id.nil? || !(c = Contract.find(@contract_id)))
        system.contract = c
        system.save!
      end
      if !(@covered.nil?)
        system.covered = @covered
        system.save!
      end
    end
  end

  def lshw_output=(val)
    # if this record has already been saved, then don't let it change.
    if id.nil?
      self._lshw_output=(val)
    end
  end

  def _lshw_output=(val)
#    write_attribute(:original_output, val)
    file = Tempfile.new("fgss-xml")
    file.write(original_output)
    file.flush
    write_attribute(:original_valid, Kernel.system("xmlstarlet val #{file.path} >/dev/null 2>/dev/null"))
    write_attribute(:cleaned_output, val.gsub(/[^[:print:]\n\t]/, ''))
    file = Tempfile.new("fgss-xml")
    file.write(cleaned_output)
    file.flush
    write_attribute(:cleaned_valid, Kernel.system("xmlstarlet val #{file.path} >/dev/null 2>/dev/null"))
  end

  def lshw_output
    if cleaned_valid
      return cleaned_output
    elsif original_valid
      return original_output
    else
      return ""
    end
  end

  def xml_is_good
    cleaned_valid || original_valid
  end

  def initialize(*args)
    super(*args)

    if !xml_is_good
      self.system_id = nil
      return
    end

    sp = SystemParser.parse(lshw_output)

    found_system = sp.find_system_id
    if found_system
      self.system = System.find_by_id(found_system)
    else
      self.system = System.new
      system.system_model  = sp.system_model
      system.system_serial_number  = sp.system_serial_number
      system.system_vendor  = sp.system_vendor
      system.mobo_model  = sp.mobo_model
      system.mobo_serial_number  = sp.mobo_serial_number
      system.mobo_vendor  = sp.mobo_vendor
      system.model  = sp.model
      system.serial_number  = sp.serial_number
      system.vendor  = sp.vendor
    end
  end
end
