class SpecSheetValue < ActiveRecord::Base
  belongs_to :spec_sheet
  belongs_to :spec_sheet_question

  def title
    self.spec_sheet_question.name.titleize
  end
end
