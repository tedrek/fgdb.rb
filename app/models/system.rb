class System < ActiveRecord::Base
  belongs_to :contract
  attr_protected :mobo_vendor, :system_vendor, :mobo_serial_number, :system_serial_number, :mobo_model, :system_model, :vendor, :serial_number, :model
  attr_readonly :mobo_vendor, :system_vendor, :mobo_serial_number, :system_serial_number, :mobo_model, :system_model, :vendor, :serial_number, :model
  validates_presence_of :vendor, :serial_number, :model
  validates_existence_of :contract
  has_many :spec_sheets
  has_many :notes
  has_many :gizmo_events
  has_many :system_pricings, :order => 'created_at ASC'

  def pricing
    system_pricings.last
  end

  def previous
    self.class.find(previous_id) if previous_id
  end

  def next
    self.class.find_by_previous_id(self.id)
  end

  def all_instances
    [self.all_next, self, self.all_previous].flatten
  end

  def all_next
    return self.next ? [self.next.all_next, self.next] : []
  end

  def all_previous
    return self.previous ? [self.previous, self.previous.all_previous] : []
  end

  def covered_s
    self.covered.to_s
  end

  def covered_s=(val)
    self.covered = eval(val)
  end

  def validate
    if self.contract.nil?
      errors.add("contract_id", "contract is not valid")
    end
  end

  def gone?
    self.gizmo_events.length > 0
  end
end
