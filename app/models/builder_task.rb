class BuilderTask < ActiveRecord::Base
  has_one :spec_sheet
  belongs_to :contact
  belongs_to :action
  validates_existence_of :action
  validates_existence_of :contact
  before_save :remove_signoff_if_contact_changed
  def remove_signoff_if_contact_changed
    self.cashier_signed_off_by = nil if contact_id_changed?
  end

  named_scope :last_two_years, :conditions => ['created_at >= ?', 2.years.ago]

  before_save :set_created_and_updated_at
  def set_created_and_updated_at
    return unless self.spec_sheet
    self.created_at = self.spec_sheet.created_at
    self.updated_at = self.spec_sheet.updated_at
  end

  # belongs_to :cashier_signed_off, :foreign_key => "cashier_signed_off_by", :class_name => "User"
  def signed_off_by
    self.cashier_signed_off_by.nil? ? "Not signed off." : User.find(self.cashier_signed_off_by).contact_display_name
  end

  def signed_off_by=(user)
    new = user.id
    self.cashier_signed_off_by = (self.cashier_signed_off_by == new ? nil : new)
  end
end

