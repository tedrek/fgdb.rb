class SpecSheetValue < ActiveRecord::Base
  belongs_to :spec_sheet
  belongs_to :spec_sheet_question

  validates_presence_of :value

  def title
    self.spec_sheet_question.name.titleize
  end
end
