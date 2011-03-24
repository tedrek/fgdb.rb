class BuilderTask < ActiveRecord::Base
  has_one :spec_sheet
  belongs_to :contact
  belongs_to :action
  validates_existence_of :action
  validates_existence_of :contact

  before_save :set_created_and_updated_at
  def set_created_and_updated_at
    return unless self.spec_sheet
    self.created_at = self.spec_sheet.created_at
    self.updated_at = self.spec_sheet.updated_at
  end
end

